import 'package:flutter/material.dart';

class AddsetPage extends StatefulWidget {
  const AddsetPage({super.key});


  @override
  State<AddsetPage> createState() => _AddsetPageState();
}

class _AddsetPageState extends State<AddsetPage> {
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
        title: Text("Add Set"),
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
