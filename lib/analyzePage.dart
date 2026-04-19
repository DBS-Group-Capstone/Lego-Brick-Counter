import 'dart:core';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:ultralytics_yolo/yolo.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as imaging;

// To use detect then classify, set this to "two-model"
// To use detect-only (for models that do both) set this to "one-model"
const String aiParadigm = "one-model";

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
  BoxPiece(this.className, this.coords);
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

  Future<void> runAI(String paradigm) async {
    setState(() => loading = true);

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
        var bc =BoxCoordinates(left, right, top, bottom);

        var crop = imaging.copyCrop(imObj, x:left, y:top, width:right - left, height:bottom - top);

        var cropped = imaging.encodePng(crop);
        var clsOuts = await useModel(model, cropped, "classifier");
        if(clsOuts != null) {
          results.add(BoxPiece(clsOuts["classification"]["name"], bc));
          bcList.add(bc);
        }
        activeImg = await applyBoxesToImage(baseImg, bcList);
      }
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
          results.add(BoxPiece(detOuts["boxes"][i]["class"], bc));
          bcList.add(bc);
        }
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
              CircularProgressIndicator()
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
            else
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: results.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 15,
                      child: Text(
                        results[index].className,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.indigo
                        )
                        )
                      );
                  }
                )
              )
          ]
        )
      )
    );
  }
}