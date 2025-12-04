import 'package:flutter/material.dart';

class SetlookupPage extends StatefulWidget {
  const SetlookupPage({super.key});


  @override
  State<SetlookupPage> createState() => _SetlookupPageState();
}

class _SetlookupPageState extends State<SetlookupPage> {
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
        title: Text("Set Lookup"),
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
