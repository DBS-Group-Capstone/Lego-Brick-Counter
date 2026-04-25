import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});


  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
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
        title: Text("Help"),
      ),
      body: Container(
        padding:EdgeInsets.all(15),
        child: Text(
          "Take a photo with the camera button or upload a photo via the images page. When viewing a photo, select the eye icon.\n\nAfter the AI runs, you will be presented with a list of pieces. Save to the database by hitting the disk icon. Discard by hitting the delete icon.\n\nTo see where the pieces were on the image, tap the piece on any surface which is not held by a button.",
          style: TextStyle(
            fontSize: 15
          )
        )
      )
    );
  }
}
