import 'package:flutter/material.dart';
// import 'package:cross_file/cross_file.dart';
// import 'package:path_provider/path_provider.dart';
import 'dart:io';
// import 'package:intl/intl.dart';
// import 'package:cross_file_image/cross_file_image.dart';
import 'package:path/path.dart';
import 'package:gal/gal.dart';

enum MenuItem {deleteImage, saveImage}

// Gives saves the image and returns a boolean determining success
Future<bool> saveAndVerify(String s) async {
  try {
    await Gal.putImage(s);
  }
  catch(e) {
    return false;
  }
  return true;
}

Future<bool> deleteAndVerify(String s) async {
  try {
    await File(s).delete();
  }
  catch(e) {
    return false;
  }
  return true;
}

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
              Navigator.of(context).pushNamed('/analyze', arguments:arg);
            },
            icon: Icon(Icons.remove_red_eye)
          ),
          PopupMenuButton<MenuItem>(
            itemBuilder: (context) => <PopupMenuEntry<MenuItem>> [
              PopupMenuItem<MenuItem>(
                value: MenuItem.saveImage,
                // Save image to gallery
                child: TextButton(
                  onPressed: () async {
                      // Gal.putImage(arg.path);
                    var did = await saveAndVerify(arg.path);
                    // Select message based on success
                    String m ="";
                    if(did) {
                      m = "File ${basename(arg.path)} saved to Gallery";
                    }
                    else {
                      m = "File did not save properly";
                    }
                    if (!context.mounted) return;

                    // Snackbar message
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(m)),
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text("Save to Gallery")
                )
              ),
              PopupMenuItem<MenuItem>(
                value: MenuItem.deleteImage,
                child: TextButton(
                  // Delete file and pop
                  onPressed: () async {
                    var did = await deleteAndVerify(arg.path);
                    // Select message based on success
                    String m ="";
                    if(did) {
                      m = "File ${basename(arg.path)} deleted.";
                    }
                    else {
                      m = "File did not delete properly";
                    }
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(m)),
                    );

                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text("Delete from app")
                )
              )
            ]
          ),
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
