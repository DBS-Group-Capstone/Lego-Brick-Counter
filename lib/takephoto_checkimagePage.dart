import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:cross_file_image/cross_file_image.dart';



class CheckimagePage extends StatefulWidget {
  const CheckimagePage({super.key});

  @override
  State<CheckimagePage> createState() => _CheckimagePageState();
}


class _CheckimagePageState extends State<CheckimagePage> {



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
            onPressed: () {
              // Save the file and return to camera
              var dir = getApplicationDocumentsDirectory();
              String name = '${DateFormat('yyyyMMdd_hhmmss').format(DateTime.now())}.png';
              arg.saveTo('$dir/$name');
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.check)
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
