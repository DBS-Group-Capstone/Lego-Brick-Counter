import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});


  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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
        title: Text("About"),
      ),
      body: Center(
        child: Text(
          'Lego Brick Binder is an object detection system that identifies Lego bricks from images using YOLO26. The Legos are then logged\nin a local collection by type, color, and size. This project started development in 2025 by a group of students.',
          style: TextStyle(
            fontSize: 30
          )
        )
      )
    );
  }
}
