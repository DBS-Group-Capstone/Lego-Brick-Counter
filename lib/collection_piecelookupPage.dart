import 'package:flutter/material.dart';

class PiecelookupPage extends StatefulWidget {
  const PiecelookupPage({super.key});


  @override
  State<PiecelookupPage> createState() => _PiecelookupPageState();
}

class _PiecelookupPageState extends State<PiecelookupPage> {
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
        title: Text("Piece Lookup"),
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
