import 'package:flutter/material.dart';

class SetmatchingPage extends StatefulWidget {
  const SetmatchingPage({super.key});


  @override
  State<SetmatchingPage> createState() => _SetmatchingPageState();
}

class _SetmatchingPageState extends State<SetmatchingPage> {
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
        title: Text("Set Matching"),
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
