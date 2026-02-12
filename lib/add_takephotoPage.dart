import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:learn/camera_provider.dart';

class TakephotoPage extends StatefulWidget {
  const TakephotoPage({super.key});

  @override
  State<TakephotoPage> createState() => _TakephotoPageState();
}

class _TakephotoPageState extends State<TakephotoPage> {
  late CameraController controller;

  //initialize camera
  @override
  void initState() {
    super.initState();

    //get list of cameras from provider
    final cameras = context.read<CameraProvider>().cameras;

    //initialize controller with first available camera
    if(cameras.isNotEmpty){
      controller = CameraController(cameras[0], ResolutionPreset.high);
      controller.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } else {
      print("No cameras found");
    }
  }
  
  //dispose of camera
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  //camera preview and capture
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
        title: Text("Take Photo"),
      ),
      body: controller.value.isInitialized
        ? CameraPreview(controller)
        : const CircularProgressIndicator(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Capture photo and go to checkimage page
            // Async and preview stuff is to prevent a bug which overflows the image buffer;
            //   pages are not destroyed until popped so going to another page leaves
            //   the camera on. If you dispose() it, you can't rebuild it. 
            controller.takePicture().then((XFile file) async {
              controller.pausePreview();
              await Navigator.of(context).pushNamed('/checkimage', arguments: file);
              controller.resumePreview();
            });
          }
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
