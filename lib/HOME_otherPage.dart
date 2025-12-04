import 'package:flutter/material.dart';
import 'package:learn/HOME_addPage.dart';
import 'package:learn/HOME_collectionPage.dart';

class OtherPage extends StatelessWidget {
  const OtherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Other"),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 2,
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)
              )
            ),
            onPressed: () {Navigator.of(context).pushNamed('/about');},
            child: Column(
              children: [
                Spacer(),
                Icon(Icons.list, size: 120),
                Spacer(),
                Text(
                  "About",
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
            onPressed: () {Navigator.of(context).pushNamed('/help');},
            child: Column(
              children: [
                Spacer(),
                Icon(Icons.question_mark, size: 120),
                Spacer(),
                Text(
                  "Help",
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
            onPressed: () {Navigator.of(context).pushNamed('/legal');},
            child: Column(
              children: [
                Spacer(),
                Icon(Icons.gavel, size: 120),
                Spacer(),
                Text(
                  "Legal",
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