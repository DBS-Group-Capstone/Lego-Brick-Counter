import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import 'package:learn/imagefile_helpers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:cross_file_image/cross_file_image.dart';



class CheckPhotoPage extends StatefulWidget {
  const CheckPhotoPage({super.key});

  @override
  State<CheckPhotoPage> createState() => _CheckPhotoPageState();
}


class _CheckPhotoPageState extends State<CheckPhotoPage> {



  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments as XFile;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Return to camera without saving
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close)
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Save?"),
        centerTitle: true,
        actions: <Widget> [
          IconButton(
            onPressed: () async {
              // Save the file and return to camera
              var dir = await getApplicationDocumentsDirectory();
              String name = '${DateFormat('yyyyMMdd_hhmmss').format(DateTime.now())}.png';
              var fulldir = Directory('${dir.path}/images');
              if(! await fulldir.exists()) {
                fulldir.create();
              }
              var argpng = await verifyPngAndRemoveEXIF(arg);
              if (argpng != null) {
                argpng.saveTo(('${fulldir.path}/$name'));
              }
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.check)
          ),
          IconButton(
            onPressed: ()  async {
              // Save the file and go to analysis
              var dir = await getApplicationDocumentsDirectory();
              String name = '${DateFormat('yyyyMMdd_hhmmss').format(DateTime.now())}.png';
              var fulldir = Directory('${dir.path}/images');
              if(! await fulldir.exists()) {
                fulldir.create();
              }
              var argpng = await verifyPngAndRemoveEXIF(arg);
              if (argpng != null) {
                argpng.saveTo(('${fulldir.path}/$name'));
              }
              var im = File('${fulldir.path}/$name');
              
              await Navigator.of(context).pushNamed('/analyze', arguments:im);
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.remove_red_eye)
          )
        ]
      ),
      body: Center(
        child: Image(
          image: XFileImage(arg),
          fit: BoxFit.contain
        )
      )
    );
  }
}
