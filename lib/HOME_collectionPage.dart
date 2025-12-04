import 'package:flutter/material.dart';
import 'package:learn/HOME_addPage.dart';
import 'package:learn/HOME_otherPage.dart';

class CollectionPage extends StatelessWidget {
  const CollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("My Collection"),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
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
            onPressed: () {Navigator.of(context).pushNamed('/mypieces');},
            child: Column(
              children: [
                Spacer(),
                Icon(Icons.shelves, size: 120),
                Spacer(),
                Text(
                  "My Pieces",
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
            onPressed: () {Navigator.of(context).pushNamed('/setmatching');},
            child: Column(
              children: [
                Spacer(),
                Icon(Icons.percent, size: 120),
                Spacer(),
                Text(
                  "Set Matching",
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
            onPressed: () {Navigator.of(context).pushNamed('/piecelookup');},
            child: Column(
              children: [
                Spacer(),
                Icon(Icons.manage_search, size: 120),
                Spacer(),
                Text(
                  "Piece Lookup",
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
            onPressed: () {Navigator.of(context).pushNamed('/setlookup');},
            child: Column(
              children: [
                Spacer(),
                Icon(Icons.image_search, size: 120),
                Spacer(),
                Text(
                  "Set Lookup",
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