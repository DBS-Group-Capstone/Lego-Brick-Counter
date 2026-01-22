import 'package:flutter/material.dart';

class TakephotoPage extends StatefulWidget {
  const TakephotoPage({super.key});

  @override
  State<TakephotoPage> createState() => _TakephotoPageState();
}

class _TakephotoPageState extends State<TakephotoPage> {
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
        title: Text("Take Photo"),
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
