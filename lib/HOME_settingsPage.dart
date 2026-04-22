import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:learn/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Settings"),
      ),

      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              "Appearance",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text("Dark Mode"),
                  subtitle: const Text("Enable dark theme"),
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme(value);
                  },
                  secondary: const Icon(Icons.dark_mode),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              "Information",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.question_mark),
                  title: const Text("Help"),
                  subtitle: const Text("How to use the app"),
                  onTap: () => Navigator.of(context).pushNamed("/help"),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8)
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text("About"),
                  subtitle: const Text("About this project"),
                  onTap: () => Navigator.of(context).pushNamed("/about"),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8)
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.gavel),
                  title: const Text("Legal"),
                  subtitle: const Text("License and disclaimer"),
                  onTap: () => Navigator.of(context).pushNamed("/legal"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}