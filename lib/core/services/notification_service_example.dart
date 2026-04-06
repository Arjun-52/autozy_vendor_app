import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_service.dart';

/// Example usage of NotificationService
/// This file shows how to use the notification service in your app
class NotificationExample extends StatefulWidget {
  const NotificationExample({super.key});

  @override
  State<NotificationExample> createState() => _NotificationExampleState();
}

class _NotificationExampleState extends State<NotificationExample> {
  final NotificationService _notificationService = NotificationService();
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    _setupNotificationListeners();
    _getFCMToken();
  }

  void _setupNotificationListeners() {
    // Listen to incoming messages (foreground)
    _notificationService.onMessage.listen((RemoteMessage message) {
      _showNotificationDialog(message, isForeground: true);
    });

    // Listen to token refresh
    _notificationService.onTokenRefresh.listen((String token) {
      setState(() {
        _fcmToken = token;
      });
      // TODO: Send new token to your backend
      print('🔄 New FCM Token: $token');
    });
  }

  Future<void> _getFCMToken() async {
    final token = await _notificationService.getToken();
    setState(() {
      _fcmToken = token;
    });
    // TODO: Send token to your backend
    print('🔑 FCM Token: $token');
  }

  void _showNotificationDialog(
    RemoteMessage message, {
    required bool isForeground,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message.notification?.title ?? 'Notification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.notification?.body ?? 'No body'),
            const SizedBox(height: 16),
            Text(
              'State: ${isForeground ? 'Foreground' : 'Background/Terminated'}',
            ),
            if (message.data.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Data:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...message.data.entries.map((e) => Text('${e.key}: ${e.value}')),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'FCM Token:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SelectableText(
              _fcmToken ?? 'Loading...',
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Instructions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('1. Copy the FCM token above'),
            const Text('2. Go to Firebase Console'),
            const Text('3. Navigate to Cloud Messaging'),
            const Text('4. Create a new campaign'),
            const Text('5. Target this specific token'),
            const Text('6. Send test notification'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _notificationService.subscribeToTopic('all_users');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Subscribed to all_users topic'),
                  ),
                );
              },
              child: const Text('Subscribe to all_users topic'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                await _notificationService.unsubscribeFromTopic('all_users');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Unsubscribed from all_users topic'),
                  ),
                );
              },
              child: const Text('Unsubscribe from all_users topic'),
            ),
          ],
        ),
      ),
    );
  }
}
