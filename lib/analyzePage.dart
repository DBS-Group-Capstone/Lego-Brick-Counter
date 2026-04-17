import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:ultralytics_yolo/yolo.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as imaging;

// To use detect then classify, set this to "two-model"
// To use detect-only (for models that do both) set this to "one-model"
const String aiParadigm = "two-model";

class AnalyzePage extends StatefulWidget {
  const AnalyzePage({super.key});

  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> {
  YOLO? yolo;
  List<String> results = [];
  bool loading = false;
  bool empty = true;
  late File img;

  @override
  void initState() {
    super.initState();
    // runAI();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    img = ModalRoute.of(context)?.settings.arguments as File;
    runAI(aiParadigm);
  }

  Future<void> runAI(String paradigm) async {
    setState(() => loading = true);

    var imgBin = await img.readAsBytes();
    
    // For detect-then-classify, two model
    if(paradigm == "two-model") {
      // Get our model from assets to storage correctly for use
      var model = File("${(await getApplicationDocumentsDirectory()).path}android/app/src/main/assets/box-detector.tflite");
      if(! await model.exists()) {
      var bytes = await rootBundle.load("assets/models/box-detector.tflite");
      await model.create(recursive:true);
      await model.writeAsBytes(bytes.buffer.asUint8List());
      }

      // Get our results from the first pass
      var boxes = (await useModel(model, imgBin, "detector"))?["boxes"] ?? [];

      // Get our second-pass model correctly for use
      model = File("${(await getApplicationDocumentsDirectory()).path}android/app/src/main/assets/classifier.tflite");
      if(! await model.exists()) {
      var bytes = await rootBundle.load("assets/models/classifier.tflite");
      await model.create(recursive:true);
      await model.writeAsBytes(bytes.buffer.asUint8List());
      }

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

        var crop = imaging.copyCrop(imObj, x:left, y:top, width:right - left, height:bottom - top);

        var cropped = imaging.encodePng(crop);
        var clsOuts = await useModel(model, cropped, "classifier");
        if(clsOuts != null) {
          results.add(clsOuts["classification"]["name"]);
        }
      }
    }

    // For detect-and-classify, one model (this is essentially the previous setup)
    else if (paradigm == "one-model") {
      // Get our model from assets to storage correctly for use
      var model = File("${(await getApplicationDocumentsDirectory()).path}android/app/src/main/assets/class-detector.tflite");
      if(! await model.exists()) {
      var bytes = await rootBundle.load("assets/models/class-detector.tflite");
      await model.create(recursive:true);
      await model.writeAsBytes(bytes.buffer.asUint8List());
      }
      // Get results
      var detOuts = await useModel(model, imgBin, "detector");

      // Add those results to our list
      if (detOuts != null) {
        for(int i = 0; i < detOuts["boxes"].length; ++i) {
        results.add(detOuts["boxes"][i]["class"]);
        }
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
            SizedBox(
              width: 250,
              height: 250,
              child: Image.file(
                img,
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
                        results[index],
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