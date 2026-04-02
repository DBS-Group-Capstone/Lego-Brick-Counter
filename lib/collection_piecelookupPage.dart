import 'package:flutter/material.dart';
import 'package:learn/database_helper.dart';
import 'package:learn/brick.dart';

class PiecelookupPage extends StatefulWidget {
  const PiecelookupPage({super.key});


  @override
  State<PiecelookupPage> createState() => _PiecelookupPageState();
}


class _PiecelookupPageState extends State<PiecelookupPage> {
  List<Brick> bricks = [];
  String colorf = "";
  String typef = "";
  String sizef = "";
  bool loading = false;


  @override
  void initState() {
    super.initState();
    loadBricks();
  }

  // Get our bricks and order them based on count
  Future<void> loadBricks() async {
    setState(() => loading = true);
    bricks = await DatabaseHelper.instance.getBricks();
    bricks.sort((a, b) {
      if(a.quantity > b.quantity) {
        return -1;
      } else if(a.quantity == b.quantity) {
        return 0;}
      else {
        return 1;}
    });

    setState(() => loading = false);
  }

  // Updates our filtering
  Future<void> addFilter(String value, String attribute) async {
    setState(() => loading = true);
    if(attribute == "color") colorf = value.toUpperCase();
    if(attribute == "type") typef = value.toUpperCase();
    if(attribute == "size") sizef = value.toUpperCase();

    setState(() => loading = false);
  }

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Color",
                border:OutlineInputBorder(),
              ),
              onChanged: (String value) {
                addFilter(value, "color"); 
              }
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "Type",
                border:OutlineInputBorder(),
              ),
              onChanged: (String value) {
                addFilter(value, "type"); 
              }
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "Size",
                border:OutlineInputBorder(),
              ),
              onChanged: (String value) {
                addFilter(value, "size"); 
              }
            ),
            if(loading) 
              CircularProgressIndicator()
            else
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: bricks.length,
                  itemBuilder: (BuildContext context, int index) {
                    var brick = bricks[index];
                    String c = "";
                    String t = "";
                    String s = "";

                    if(brick.color.length > colorf.length) {
                      c = brick.color.toUpperCase().substring(0, colorf.length);
                    } else {
                      c = brick.color.toUpperCase();
                    }
                    if(brick.type.length > typef.length) {
                      t = brick.type.toUpperCase().substring(0, typef.length);
                    } else {
                      t = brick.type.toUpperCase();
                    }
                    if(brick.size.length > sizef.length) {
                      s = brick.size.toUpperCase().substring(0, sizef.length);
                    } else {
                      s = brick.size.toUpperCase();
                    }

                    if((c == colorf || colorf == "")
                      && (t == typef || typef == "")
                      && (s == sizef || sizef == "")
                      && brick.quantity > 0) {
                      return Card(
                        child: ListTile(
                          // TODO: This leading: icon is a placeholder.
                          //   This should be replaced by an image of the piece once we
                          //   have our final piece list
                          leading: Icon(Icons.square),
                          title: Text("${brick.color} - ${brick.type} (${brick.size})"),
                          subtitle: Text("Quantity: ${brick.quantity}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(icon: Icon(Icons.remove), onPressed: () {
                                brick.quantity -= 1;
                                if (brick.quantity < 0) brick.quantity = 0;
                                DatabaseHelper.instance.updateBrick(brick);
                                loadBricks();
                              }),
                              IconButton(icon: Icon(Icons.add), onPressed: () {
                                brick.quantity += 1;
                                DatabaseHelper.instance.updateBrick(brick);
                                loadBricks();
                              }),
                              IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () {
                                // The ID is a primary key, it should NEVER be null, but who knows what
                                //   logical errors lurk from when it was copied from the db?
                                if(brick.id != null) DatabaseHelper.instance.deleteBrick(brick.id!);
                                loadBricks();
                              }),
                            ],
                          ),
                        ),
                      );
                    }
                    // Empty, 0x0 box
                    else {
                      return SizedBox(
                      height: 0,
                      width: 0,
                      );
                    }
                  }
                )
              )
          ]
        )
      )
    );
  }
}