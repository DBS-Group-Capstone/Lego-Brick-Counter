import 'package:flutter/material.dart';
import 'package:learn/HOME_collectionPage.dart';
import 'package:learn/HOME_otherPage.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Add to collection"),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (int index) {
          switch (index) {
            case 0: Navigator.pushReplacement(
             context, 
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => AddPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
            case 1: Navigator.pushReplacement(
             context, 
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => CollectionPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
            case 2: Navigator.pushReplacement(
             context, 
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => OtherPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.plus_one),
            label: "Add to Collection"
          ),
          NavigationDestination(
            icon: Icon(Icons.home),
            label: "My Collection"
          ),
          NavigationDestination(
            icon: Icon(Icons.square),
            label: "Other"
          )]
        ),
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
            onPressed: () {Navigator.of(context).pushNamed('/takephoto');},
            child: Column(
              children: [
                Spacer(),
                Icon(Icons.camera_alt, size: 120),
                Spacer(),
                Text(
                  "Take Photo",
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
            onPressed: () {Navigator.of(context).pushNamed('/uploadphoto');},
            child: Column(
              children: [
                Spacer(),
                Icon(Icons.add_photo_alternate, size: 120),
                Spacer(),
                Text(
                  "Upload",
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
            onPressed: () {Navigator.of(context).pushNamed('/addset');},
            child: Column(
              children: [
                Spacer(),
                Icon(Icons.castle, size: 120),
                Spacer(),
                Text(
                  "Add Set",
                  style: TextStyle(
                    fontSize: 20
                  )
                )
              ]
            )
          )
        ]
      )
    );
  }
}