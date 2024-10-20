import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.green, // Choose a color for your app bar
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Example notification items
          _buildNotificationItem('New order placed',
              'Your order #1234 has been placed successfully.'),
          _buildNotificationItem(
              'Promo alert', 'Get 20% off on your next purchase!'),
          _buildNotificationItem(
              'Item shipped', 'Your order #1234 has been shipped.'),
          // Add more notifications as needed
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Handle item tap (e.g., navigate to a detailed view)
        },
      ),
    );
  }
}
