import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushNamed(context, '/'); // Navigate to Home Page
            },
          ),
        ],
      ),//appbar
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: notificationsEnabled,
            onChanged: (value) {
              setState(() {
                notificationsEnabled = value;
              });//notifications opiton
            },
          ),
          ListTile(
            title: const Text('Change Password'),
            onTap: () {},
          ),//change password option
          ListTile(
            title: const Text('Log Out'),
            onTap: () {
              Navigator.pop(context);
            },//logout option
          ),
        ],
      ),
    );
  }
}
