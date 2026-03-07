import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:ultralytics_yolo/yolo.dart';
import 'package:flutter/services.dart';

class AnalyzePage extends StatefulWidget {
  const AnalyzePage({super.key});


  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> {
  YOLO? ai;
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
    runAI();
  }

  Future<void> runAI() async {
    setState(() => loading = true);

    // It has to be here
    var model = File("${(await getApplicationDocumentsDirectory()).path}android/app/src/main/assets/yolo26_dbs.tflite");
    // If it isn't, put it there.
    if(! await model.exists()) {
      var bytes = await rootBundle.load("assets/models/yolo26_dbs.tflite");
      await model.create(recursive:true);
      await model.writeAsBytes(bytes.buffer.asUint8List());
    }

    // init
    ai = YOLO(
      modelPath: model.path,
      task: YOLOTask.detect,
      useGpu: false
    );
    await ai!.loadModel();

    // identify
    var imgBin = await img.readAsBytes();
    var out = (await ai!.predict(imgBin))['boxes'] ?? [];

    for(int i = 0; i < out.length; ++i) {
      results.add(out[i]["class"]);
    }

    setState(() => empty = results.isEmpty);
    setState(() => loading = false);
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