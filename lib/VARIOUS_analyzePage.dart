import 'dart:core';

import 'package:flutter/material.dart';
import 'package:learn/database_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:ultralytics_yolo/yolo.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as imaging;
import 'brick.dart';

// To use detect then classify, set this to "two-model"
// To use detect-only (for models that do both) set this to "one-model"
const String aiParadigm = "two-model";

class BoxCoordinates {
  int left;
  int right;
  int top;
  int bottom;
  BoxCoordinates(this.left, this.right, this.top, this.bottom);
}

class BoxPiece {
  String className;
  BoxCoordinates coords;
  String color;
  BoxPiece(this.className, this.coords, this.color);
}

// Draws red boxes upon an image
Future <Uint8List?> applyBoxesToImage(File base, List<BoxCoordinates> co) async {
  var newImg = imaging.decodeImage(await base.readAsBytes());

  if(newImg != null) {
    // Draw a rectangle for each BoxCoordinates object
    for (var cos in co) {
      imaging.drawRect(
        newImg, 
        x1: cos.left, 
        y1: cos.top, 
        x2: cos.right, 
        y2: cos.bottom, 
        color: imaging.ColorUint8.rgba(255, 0, 0, 255),
        thickness: 9
      );
    }
    return imaging.encodePng(newImg);
  }
  else {
    // Empty image
    return null;
  }
}

class AnalyzePage extends StatefulWidget {
  const AnalyzePage({super.key});

  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> {
  YOLO? yolo;
  List<BoxPiece> results = [];
  List<Brick>? finds;
  bool loading = false;
  bool empty = true;
  late File baseImg;
  Uint8List? activeImg;

  @override
  void initState() {
    super.initState();
    // runAI();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    baseImg = ModalRoute.of(context)?.settings.arguments as File;
    () async => activeImg = await baseImg.readAsBytes();
    runAI(aiParadigm);
  }
  // Populates the list of finds
  // This should not pop if there are no finds because the user will want to
  //   see the prompt saying nothing was identified.
  void populateFinds() {
    if(results.isNotEmpty && finds == null) {
      List<Brick> f = [];
      for (var bp in results) {
        var b = Brick.fromStrings(bp.className, bp.color);
        if (b != null) {
          int i = f.indexWhere(
            (brick) => 
              brick.type == b.type && brick.size == b.size && brick.color == b.color
          );
          if (i >= 0) {
            f[i].quantity += 1;
          } 
          else {
            f.add(b);
          }
        }
      }
      if (f.isNotEmpty) {
        // finds = f;
        setState(() {finds = f;});
      }
    }
  }

  String findColor(imaging.Pixel img) {
    num r = img.r;
    num g = img.g;
    num b = img.b;

    // Get average pixel 

    
    // Output based on average values
    if(r > 150 && g > 150 && b > 150) {
      return "White";
    }
    if(r < 30 && g < 30 && b < 30) {
      return "Black";
    }
    if(g > r * 1.1 && g > b * 1.1) {
      return "Green";
    }
    if(r > g * 1.1 && r > b * 1.1) {
      return "Red";
    }
    if(b > g * 1.1 && b > r * 1.1) {
      return "Blue";
    }
    var avg = r + g + b / 3;
    if((r - avg).abs() < 20 && (g - avg).abs() < 20 &&( b - avg).abs() < 20) {
      return "Gray";
    }
    if(r > avg && g > avg && b <= avg) {
      return "Yellow";
    }
    if(g > avg && b > avg && r <= avg) {
      return "Cyan";
    }
    if(r > avg && b > avg && g <= avg) {
      return "Purple";
    }
    return "Other";
  }

  // Updates the count on the modifiable list of finds and resets state
  // I'm thinking this should not disappear if it goes to zero; too easy
  //   to accidentally delete pieces while modifying heavily here.
  void updateFindCount(int index, int amount) {
    if (finds != null) {
      if (index < finds!.length) {
        var c = finds![index].quantity + amount;
        if (c >= 0) {
          finds![index].quantity = c;
        }
      }
    }
    setState(() {});
  }
  // Saves find to database, if that's the last find, leave page.
  void saveFind(int index) async {
    if (finds != null) {
      if (index < finds!.length) {
        if (finds![index].quantity < 1) {
          finds!.removeAt(index);
          return;
        }
        else {
          await DatabaseHelper.instance.insertBrickAccumulate(finds![index]);
          finds!.removeAt(index);
        }
      }
      if(finds!.isEmpty) {
        if (!mounted) return;
        Navigator.of(context).pop();
      }
    }
    setState(() {});
  }
  // Removes find from list; if no more finds, leave page
  void removeFind(int index) {
    if (finds != null) {
      if (index < finds!.length) {
        finds!.removeAt(index);
      }
      if(finds!.isEmpty) {
        if (!mounted) return;
        Navigator.of(context).pop();
      }
    }
    setState(() {});

  }

  Future<void> runAI(String paradigm) async {
    setState(() => loading = true);

    // This is to give the page time to fully load; it gets choppy when the AI runs
    await Future.delayed(Duration(milliseconds: 750));

    var imgBin = await baseImg.readAsBytes();
    
    // For detect-then-classify, two model
    if(paradigm == "two-model") {
      // Get our model from assets to storage correctly for use
      var model = File("${(await getApplicationDocumentsDirectory()).path}/models/box-detector.tflite");
      if(! await model.exists()) {
      var bytes = await rootBundle.load("assets/models/box-detector.tflite");
      await model.create(recursive:true);
      await model.writeAsBytes(bytes.buffer.asUint8List());
      }

      // Get our results from the first pass
      var boxes = (await useModel(model, imgBin, "detector"))?["boxes"] ?? [];

      // Get our second-pass model correctly for use
      model = File("${(await getApplicationDocumentsDirectory()).path}/models/classifier.tflite");
      if(! await model.exists()) {
      var bytes = await rootBundle.load("assets/models/classifier.tflite");
      await model.create(recursive:true);
      await model.writeAsBytes(bytes.buffer.asUint8List());
      }

      // List of box coordinates
      List<BoxCoordinates> bcList = [];

      // For each box
      for (var box in boxes) {
        // Convert to an image format we can crop
        final imObj = imaging.decodeImage(imgBin);
        if (imObj == null) {
          continue;
        }

        // Get the bounds
        final left = (box["x1"] as num).round();
        final right = (box["x2"] as num).round();
        final top = (box["y1"] as num).round();
        final bottom = (box["y2"] as num).round();

        // Add to BoxCoordinates object
        //   This is for the user display so should not be made sqauare
        var bc =BoxCoordinates(left, right, top, bottom);

        int width = right - left;
        int height = bottom - top;
        int diff = height - width;

        int croppedLeft = left;
        int croppedTop = top;
        int croppedRight = right;
        int croppedBottom = bottom;
        
        // Get coordinates for a square
        if(diff > 0) {
          croppedLeft -= (diff/2).round();
          croppedRight = height + croppedLeft;
        }
        else {
          croppedTop -= -(diff/2).round();
          croppedBottom = width + croppedTop;
        }

        // Crop that square
        var crop = imaging.copyCrop(imObj, x:croppedRight, y:croppedTop, width:croppedRight - croppedLeft, height:croppedBottom - croppedTop);

        var cropped = imaging.encodePng(crop);
        var color = findColor(crop.getPixel((croppedRight - croppedLeft / 2).round(), (croppedRight - croppedLeft).round()));
        var clsOuts = await useModel(model, cropped, "classifier");
        if(clsOuts != null) {
          results.add(BoxPiece(clsOuts["classification"]["name"], bc, color));
          bcList.add(bc);
        }
      }
        populateFinds();
        activeImg = await applyBoxesToImage(baseImg, bcList);
    }

    // For detect-and-classify, one model (this is essentially the previous setup)
    else if (paradigm == "one-model") {
      // Get our model from assets to storage correctly for use
      var model = File("${(await getApplicationDocumentsDirectory()).path}/models/class-detector.tflite");
      if(! await model.exists()) {
      var bytes = await rootBundle.load("assets/models/class-detector.tflite");
      await model.create(recursive:true);
      await model.writeAsBytes(bytes.buffer.asUint8List());
      }
      // Get results
      var detOuts = await useModel(model, imgBin, "detector");
      // Add those results to our list
      if (detOuts != null) {
        List<BoxCoordinates> bcList = [];
        for(int i = 0; i < detOuts["boxes"].length; ++i) {
          var bc = BoxCoordinates(
            (detOuts["boxes"][i]["x1"] as num).round(),
            (detOuts["boxes"][i]["x2"] as num).round(),
            (detOuts["boxes"][i]["y1"] as num).round(),
            (detOuts["boxes"][i]["y2"] as num).round(),
          );

          // Crop bounding box to get color
          final imObj = imaging.decodeImage(imgBin);
          String color = "";
          if(imObj != null) {
            color = findColor(imObj.getPixel((bc.right - bc.left / 2).round(), (bc.bottom - bc.top / 2).round()));
          }
          results.add(BoxPiece(detOuts["boxes"][i]["class"], bc, color));
          bcList.add(bc);
        }
        populateFinds();
        activeImg = await applyBoxesToImage(baseImg, bcList);
      }
    }

    setState(() => empty = results.isEmpty);
    setState(() => loading = false);
  }

  // The plugin acts crazy when more than one model is loaded at the same time, even if in separate vars, hence this function
  Future<Map<String, dynamic>?> useModel(File m, Uint8List img, String type) async {
    try {
      if(type == "detector") {
        yolo = YOLO(
          modelPath: m.path,
          task: YOLOTask.detect,
          useGpu: false
        );
        var result = await yolo!.predict(img);
        await yolo!.dispose();
        return result;
      }
      else if (type == "classifier") {
        yolo = YOLO(
          modelPath: m.path,
          task: YOLOTask.classify,
          useGpu: false
        );
        var result = await yolo!.predict(img);
        await yolo!.dispose();
        return result;
      }
      else {
        return null;
      }
    }
    // Very simple try/catch block but it can be refined later to diagnose specifics if issues arise
    catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back)
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("AI Analysis"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (activeImg != null) 
            SizedBox(
              width: 250,
              height: 250,
              child: 
                Image.memory(
                activeImg!,
                fit:BoxFit.contain)
            )
            else
            SizedBox(
              width: 250,
              height: 250,
              child: 
                Image.file(
                baseImg,
                fit:BoxFit.contain)
            ),
            if(loading) 
              Expanded(
                child: Center(child: CircularProgressIndicator())
                )
            else if(empty && !loading)
              Center(
                child: Text(
                  '(No Objects Detected)',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 30
                  )
                )
              )
            else if (!empty && finds != null)
              Expanded(
                child: ListView.builder(
                  itemCount: finds!.length,
                  itemBuilder: (context, index) {
                    final brick = finds![index];
                    return Card(
                      child: ListTile(
                        title: Text("${brick.color} - ${brick.type} (${brick.size})"),
                        subtitle: Text("Quantity: ${brick.quantity}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: Icon(Icons.remove), onPressed: () => updateFindCount(index, -1)),
                            IconButton(icon: Icon(Icons.add), onPressed: () => updateFindCount(index, 1)),
                            IconButton(icon: Icon(Icons.save), onPressed: () => saveFind(index)),
                            IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => removeFind(index)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ]
        )
      )
    );
  }
}