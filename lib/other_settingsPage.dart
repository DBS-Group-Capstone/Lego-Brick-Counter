import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});


  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkMode = false;
  bool notifications = true;

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
        title: Text("Settings"),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),

          // Appearance section
          _sectionHeader("Appearance"),
          SwitchListTile(
            title: Text("Dark Mode"),
            subtitle: const Text("Enable dark theme for the app"),
            value: darkMode,
            onChanged: (value) {
              setState(() {
                darkMode = value;
              });
            },
            secondary: const Icon(Icons.dark_mode),
          ),

          const Divider(),

          // Notifications section
          _sectionHeader("Notifications"),
          SwitchListTile(
            title: Text("Enable Notifications"),
            subtitle: const Text("Receive notifications for updates"),
            value: notifications,
            onChanged: (value) {
              setState(() {
                notifications = value;
              });
            },
            secondary: const Icon(Icons.notifications),
          ),
        ],
      ),
    );
  }
}

Widget _sectionHeader(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    ),
  );
}
