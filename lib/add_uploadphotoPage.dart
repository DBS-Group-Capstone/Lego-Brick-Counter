import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class UploadphotoPage extends StatefulWidget {
  const UploadphotoPage({super.key});


  @override
  State<UploadphotoPage> createState() => _UploadphotoPageState();
}

class _UploadphotoPageState extends State<UploadphotoPage> {
  List<File> imageList = [];

  @override
  void initState() {
    super.initState();
    count();
  }

  // For initState override; finds and counts images in folder
  Future<void> count() async {
    final apdodi = await getApplicationDocumentsDirectory();
    final dir =  Directory('${apdodi.path}/images');

    if(await dir.exists()) {
      List<FileSystemEntity> images = dir.listSync();
      setState(() {
        imageList = images.whereType<File>().toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageList.isEmpty) { 
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Images"),
        ),
        body: Center(
          child: Text(
            '(No images saved)',
            style: TextStyle(
              color: Colors.red,
              fontSize: 30
            )
          )
        )
      );
    }

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Images"),
          actions: <Widget> [
            IconButton(
              onPressed: () {
                // TODO: Nav to page for copying from filesystem
              },
              icon: Icon(Icons.add)
            )
          ]
        ),
        body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, 
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: imageList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Upon return, resets state
                Navigator.of(context).pushNamed('/viewimage', arguments: imageList[index]).then((_) {
                  setState(() {
                    count();
                  });
                });
              },
              child: Image.file(
                imageList[index],
                fit: BoxFit.cover,
                width: 100,
                height: 100
              )
            );
          }
        )
      );
  }
}
