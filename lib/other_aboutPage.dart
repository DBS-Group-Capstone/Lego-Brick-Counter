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
          'Lego Brick Counter is an objcet detection system that identifies and logs Lego bricks from images.\nThis project started development in 2025 by a group of students.',
          style: TextStyle(
            //color: Colors.red,
            fontSize: 30
          )
        )
      )
    );
  }
}
