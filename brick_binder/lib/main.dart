import 'package:flutter/material.dart';

/// Flutter code sample for [NavigationBar].

void main() => runApp(const BrickBinder());

class BrickBinder extends StatelessWidget {
  const BrickBinder({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: NavPanel());
  }
}

class NavPanel extends StatefulWidget {
  const NavPanel({super.key});

  @override
  State<NavPanel> createState() => _NavPanelState();
}

class _NavPanelState extends State<NavPanel> {
  int currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold
    (
      appBar: AppBar
      (
        backgroundColor: const Color.fromARGB(253, 255, 213, 2), 
        title: Center(child: const Text('Brick Binder'))
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: const Color.fromARGB(253, 255, 213, 2),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.camera_alt),
            label: 'Camera',
          ),
          NavigationDestination(
            icon: Badge(label: Text('2'), child: Icon(Icons.book)),
            label: 'Collection',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.settings)),
            label: 'Settings',
          ),
        ],
      ),
      body: <Widget>[
        /// Camera
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(child: Text('Home page', style: theme.textTheme.titleLarge)),
          ),
        ),

        /// Collection
        GridView.count
        (
          crossAxisCount: 3,
          padding: EdgeInsets.all(16.0),
          childAspectRatio: 8.0 / 9.0,
          children: <Widget>
          [
            Card
            (
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 18.0 / 11.0,
                    child: Icon(Icons.square),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Title'),
                        const SizedBox(height: 8.0),
                        Text('Secondary Text'),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],

        
          /*child: Column(
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 1'),
                  subtitle: Text('This is a notification'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 2'),
                  subtitle: Text('This is a notification'),
                ),
              ),
            ],
          ),*/
        ),

        /// Settings
        ListView.builder
        (
          //reverse: true,
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) 
          {
            if (index == 0) 
            {
              return Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Hello',
                    style: theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onPrimary),
                  ),
                ),
              );
            }
            return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Hi!',
                  style: theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onPrimary),
                ),
              ),
            );
          },
        ),
      ][currentPageIndex],
    );
  }
}

/*class LegoCard extends StatelessWidget 
{
  
  const LegoCard({required this.cardName});
  final String cardName;

  @override
  Widget build(BuildContext context) 
  {
    return SizedBox(width: 300, height: 100, child: Center(child: Text(cardName)));
  }
}*/