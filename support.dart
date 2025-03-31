import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override//appbar
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
          ),
         
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Need Help?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Contact us at: support@vibe.com'),//email id
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Chat with Support'),//chat option
            ),
          ],
        ),
      ),
    );
  }
}