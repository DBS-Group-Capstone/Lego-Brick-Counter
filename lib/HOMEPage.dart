import 'package:flutter/material.dart';

class HOMEPage extends StatelessWidget {
  const HOMEPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Brick Binder"),
      ),
      persistentFooterButtons: [
        Center (
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pushNamed("/takephoto"),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(200, 80),
            ),
            child: Column (
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt,
                  size: 34,
                ),
                Text("Take Photo")
              ]
            )
          )
        ),
      ],
      body: GridView.count(
        childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 2),
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)
              )
            ),
            onPressed: () {Navigator.of(context).pushNamed('/inventory');},
            child: Column(
              children: [
                Spacer(),
                Icon(Icons.shelves, size: 120),
                Spacer(),
                Text(
                  "Inventory",
                  style: TextStyle(
                    fontSize: 20
                  )
                )
              ]
            )
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)
              )
            ),
            onPressed: () {Navigator.of(context).pushNamed('/images');},
            child: Column(
              children: [
                Spacer(),
                Icon(Icons.add_photo_alternate, size: 120),
                Spacer(),
                Text(
                  "Images",
                  style: TextStyle(
                    fontSize: 20
                  )
                )
              ]
            )
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)
              )
            ),
            onPressed: () {Navigator.of(context).pushNamed('/settings');},
            child: Column(
              children: [
                Spacer(),
                Icon(Icons.settings, size: 120),
                Spacer(),
                Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 20
                  )
                )
              ]
            )
          ),
        ]
      )
    );
  }
}