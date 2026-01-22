import 'package:flutter/material.dart';

// Page /collection currently not used in lieu of /data

class MypiecesPage extends StatefulWidget {
  const MypiecesPage({super.key});


  @override
  State<MypiecesPage> createState() => _MypiecesPageState();
}

class _MypiecesPageState extends State<MypiecesPage> {
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
        title: Text("My Pieces"),
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
