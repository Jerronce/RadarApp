import 'package:flutter/material.dart';
import 'main.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // We create boolean variables to hold the state of each switch.
  bool _isDarkMode = false;
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _dataSaver = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      // We use a ListView to ensure the content is scrollable if more settings are added.
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // -- DARK MODE --
          ListTile(
            title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Switch(
              value: _isDarkMode,
              onChanged: (bool value) {
                setState(() {
                  _isDarkMode = value;
                  // In a real app, you would add logic here to change the app's theme.
                });
              },
            ),
          ),
          const Divider(), // A visual separator line

          // -- PUSH NOTIFICATIONS --
          ListTile(
            title: const Text('Push Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Switch(
              value: _pushNotifications,
              onChanged: (bool value) {
                setState(() {
                  _pushNotifications = value;
                });
              },
            ),
          ),
          const Divider(),

          // -- EMAIL NOTIFICATIONS --
          ListTile(
            title: const Text('Email Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Switch(
              value: _emailNotifications,
              onChanged: (bool value) {
                setState(() {
                  _emailNotifications = value;
                });
              },
            ),
          ),
          const Divider(),

          // -- DATA SAVER --
          ListTile(
            title: const Text('Data Saver', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Reduces data usage over mobile network'),
            trailing: Switch(
              value: _dataSaver,
              onChanged: (bool value) {
                setState(() {
                  _dataSaver = value;
                });
              },
            ),
          ),
          const Divider(),
          const SizedBox(height: 40),

          // -- LOG OUT BUTTON --
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.1),
              foregroundColor: Colors.red,
            ),
            onPressed: () {
              // Logic to log the user out and return to the login screen
              // This command removes all the screens on top (Homepage, Settings, etc.)
              // and navigates back to the very first screen of your app.
              // This ensures a clean logout.
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Radar')), // Navigates to your login page
                    (Route<dynamic> route) => false,
              );

            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
