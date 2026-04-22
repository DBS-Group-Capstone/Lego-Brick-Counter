import 'package:flutter/material.dart';
import 'brick.dart';
import 'database_helper.dart';

class AddPiecesPage extends StatefulWidget {
  const AddPiecesPage({super.key});

  @override
  _AddPiecesPageState createState() => _AddPiecesPageState();
}

class _AddPiecesPageState extends State<AddPiecesPage> {
  List<Brick> bricks = [];

  final colorController = TextEditingController();
  final sizeController = TextEditingController();
  final typeController = TextEditingController();
  final quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadBricks();
  }

  Future loadBricks() async {
    bricks = await DatabaseHelper.instance.getBricks();
    setState(() {});
  }

  Future addBrick() async {
    final newBrick = Brick(
      color: colorController.text,
      size: sizeController.text,
      type: typeController.text,
      quantity: int.tryParse(quantityController.text) ?? 0,
    );

    await DatabaseHelper.instance.insertBrick(newBrick);
    clearInputs();
    loadBricks();
  }

  void clearInputs() {
    colorController.clear();
    sizeController.clear();
    typeController.clear();
    quantityController.clear();
  }

  Future updateQuantity(Brick brick, int delta) async {
    brick.quantity += delta;
    if (brick.quantity < 0) brick.quantity = 0;
    await DatabaseHelper.instance.updateBrick(brick);
    loadBricks();
  }

  Future deleteBrick(int id) async {
    await DatabaseHelper.instance.deleteBrick(id);
    loadBricks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Pieces")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(controller: colorController, decoration: InputDecoration(labelText: "Color")),
                TextField(controller: sizeController, decoration: InputDecoration(labelText: "Size")),
                TextField(controller: typeController, decoration: InputDecoration(labelText: "Type")),
                TextField(controller: quantityController, decoration: InputDecoration(labelText: "Quantity")),
                SizedBox(height: 10),
                ElevatedButton(onPressed: addBrick, child: Text("Add Brick"))
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: bricks.length,
              itemBuilder: (context, index) {
                final brick = bricks[index];
                return Card(
                  child: ListTile(
                    title: Text("${brick.color} - ${brick.type} (${brick.size})"),
                    subtitle: Text("Quantity: ${brick.quantity}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: Icon(Icons.remove), onPressed: () => updateQuantity(brick, -1)),
                        IconButton(icon: Icon(Icons.add), onPressed: () => updateQuantity(brick, 1)),
                        IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => deleteBrick(brick.id!)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
