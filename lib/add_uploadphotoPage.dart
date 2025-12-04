import 'package:flutter/material.dart';

class UploadphotoPage extends StatefulWidget {
  const UploadphotoPage({super.key});


  @override
  State<UploadphotoPage> createState() => _UploadphotoPageState();
}

class _UploadphotoPageState extends State<UploadphotoPage> {
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
        title: Text("Upload Photo"),
      ),
      body: Center(
        child: Text(
          '(To be implemented)',
          style: TextStyle(
            color: Colors.red,
            fontSize: 30
          )
        )
      )
    );
  }
}
