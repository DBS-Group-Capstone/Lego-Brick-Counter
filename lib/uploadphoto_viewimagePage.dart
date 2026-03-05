import 'package:flutter/material.dart';
// import 'package:cross_file/cross_file.dart';
// import 'package:path_provider/path_provider.dart';
import 'dart:io';
// import 'package:intl/intl.dart';
// import 'package:cross_file_image/cross_file_image.dart';
import 'package:path/path.dart';



class ViewimagePage extends StatefulWidget {
  const ViewimagePage({super.key});

  @override
  State<ViewimagePage> createState() => _ViewimagePageState();
}


class _ViewimagePageState extends State<ViewimagePage> {



  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments as File;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Return to page without deleting
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back)
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(basename(arg.path)),
        centerTitle: true,
        actions: <Widget> [
          IconButton(
            onPressed: ()  {
              // Delete the file and return
              File(arg.path).delete();
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.delete_forever)
          ),
          IconButton(
            onPressed: ()  {
              Navigator.of(context).pushNamed('/analyze', arguments:arg);
            },
            icon: Icon(Icons.remove_red_eye)
          )
        ],
      ),
      body: Center(
        child: Image.file(
          arg,
          fit: BoxFit.contain
        )
      )
    );
  }
}
