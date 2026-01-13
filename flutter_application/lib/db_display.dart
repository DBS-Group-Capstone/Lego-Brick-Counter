import 'package:flutter/material.dart';
import '../piece_data.dart';

class DataDisplay extends StatefulWidget {
  const DataDisplay({super.key});

  @override
  State<DataDisplay> createState() => _DataDisplayState();
}

class _DataDisplayState extends State<DataDisplay> {
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    final data = await DatabaseHelper.getAllPieces();
    setState(() {
      items = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Database Items')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]['name']),
          );
        },
      ),
    );
  }
}