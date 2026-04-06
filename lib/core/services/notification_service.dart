import 'dart:async';
import 'dart:developer' as developer;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Clean, scalable Firebase Cloud Messaging service
/// Handles all push notification functionality in a centralized way
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Stream controllers for handling different notification states
  final StreamController<RemoteMessage> _messageStreamController =
      StreamController<RemoteMessage>.broadcast();
  final StreamController<String> _tokenStreamController =
      StreamController<String>.broadcast();

  // Public streams for other parts of the app to listen to
  Stream<RemoteMessage> get onMessage => _messageStreamController.stream;
  Stream<String> get onTokenRefresh => _tokenStreamController.stream;

  /// Initialize Firebase Messaging and set up all listeners
  /// Call this once when app starts (typically in main.dart or splash screen)
  Future<void> initialize() async {
    try {
      // Request notification permissions (required for Android 13+)
      await _requestPermissions();

      // Get initial message if app was opened from notification
      final RemoteMessage? initialMessage = await _messaging
          .getInitialMessage();
      if (initialMessage != null) {
        _handleMessage(initialMessage, isInitialMessage: true);
      }

      // Set up foreground message handler
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Set up background message handler (when app is opened from notification)
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      // Set up token refresh handler
      _messaging.onTokenRefresh.listen(_handleTokenRefresh);

      // Get initial token
      await _getToken();

      developer.log('NotificationService initialized successfully');
    } catch (e) {
      developer.log(' Error initializing NotificationService: $e');
    }
  }

  /// Request notification permissions for Android 13+ and iOS
  Future<void> _requestPermissions() async {
    // Android 13+ (API 33) requires POST_NOTIFICATIONS permission
    if (defaultTargetPlatform == TargetPlatform.android) {
      final status = await Permission.notification.request();
      developer.log('🔔 Notification permission status: $status');

      if (status.isGranted) {
        developer.log(' Notification permission granted');
      } else {
        developer.log(' Notification permission denied');
      }
    }

    // Request iOS permissions (alert, badge, sound)
    await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    final settings = await _messaging.getNotificationSettings();
    developer.log(
      ' iOS notification settings: ${settings.authorizationStatus}',
    );
  }

  /// Get FCM device token for sending push notifications
  /// This token can be sent to your backend for targeted notifications
  Future<String?> getToken() async {
    return await _getToken();
  }

  /// Internal method to get and handle FCM token
  Future<String?> _getToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        developer.log(' FCM Token: $token');
        developer.log(
          ' Send this token to your backend for push notifications',
        );
        return token;
      }
    } catch (e) {
      developer.log(' Error getting FCM token: $e');
    }
    return null;
  }

  /// Handle messages when app is in foreground
  void _handleForegroundMessage(RemoteMessage message) {
    developer.log(' Received foreground message: ${message.messageId}');
    developer.log(' Title: ${message.notification?.title}');
    developer.log(' Body: ${message.notification?.body}');
    developer.log(' Data: ${message.data}');

    // Add message to stream for UI to handle
    _messageStreamController.add(message);
  }

  /// Handle messages when app is opened from notification (background)
  void _handleMessageOpenedApp(RemoteMessage message) {
    developer.log(' App opened from notification: ${message.messageId}');
    _handleMessage(message, isInitialMessage: false);
  }

  /// Handle messages when app is launched from terminated state
  void _handleMessage(RemoteMessage message, {required bool isInitialMessage}) {
    developer.log(
      ' ${isInitialMessage ? "Initial" : "Background"} message: ${message.messageId}',
    );
    developer.log(' Title: ${message.notification?.title}');
    developer.log(' Body: ${message.notification?.body}');
    developer.log(' Data: ${message.data}');

    // Add message to stream for UI to handle
    _messageStreamController.add(message);

    // TODO: Navigate to specific screen based on message data
    // Example: if (message.data['screen'] == 'orders') { navigateToOrders(); }
  }

  /// Handle FCM token refresh
  void _handleTokenRefresh(String token) {
    developer.log(' FCM Token refreshed: $token');
    developer.log(' Send this new token to your backend');

    // Add token to stream for other parts of the app to handle
    _tokenStreamController.add(token);
  }

  /// Subscribe to a topic for receiving notifications
  /// Useful for sending notifications to groups of users
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      developer.log(' Subscribed to topic: $topic');
    } catch (e) {
      developer.log('Error subscribing to topic $topic: $e');
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      developer.log(' Unsubscribed from topic: $topic');
    } catch (e) {
      developer.log(' Error unsubscribing from topic $topic: $e');
    }
  }

  /// Clean up resources when service is no longer needed
  void dispose() {
    _messageStreamController.close();
    _tokenStreamController.close();
  }

  /// Simple method to get FCM token once and print it
  /// Call this at app start to get your token for Firebase Console testing
  static Future<void> generateAndPrintFCMToken() async {
    try {
      final messaging = FirebaseMessaging.instance;

      print(" STARTING TOKEN FETCH");

      NotificationSettings settings = await messaging.requestPermission();

      print(" Permission: ${settings.authorizationStatus}");

      String? token = await messaging.getToken();

      print(" FCM TOKEN: $token");

      if (token == null) {
        print(" TOKEN IS NULL");
      }
    } catch (e) {
      print(" ERROR: $e");
    }
    try {
      // Request notification permission first
      final messaging = FirebaseMessaging.instance;

      // Request permission for Android 13+ and iOS
      await messaging.requestPermission(alert: true, badge: true, sound: true);

      // Get FCM token
      final token = await messaging.getToken();

      if (token != null) {
        // Print token in debug console - copy this for Firebase Console
        developer.log(' FCM Token Generated Successfully!');
        developer.log(' Copy this token to Firebase Console:');
        developer.log(' $token');
        developer.log(
          'Go to Firebase Console → Cloud Messaging → Create Campaign → Target this token',
        );
      } else {
        developer.log(' Failed to generate FCM token');
      }
    } catch (e) {
      developer.log(' Error generating FCM token: $e');
    }
  }
}

/// Extension to make NotificationService usage more convenient
extension NotificationServiceExtension on NotificationService {
  /// Quick method to show a local notification (for testing)
  void showTestNotification() {
    developer.log(
      ' Test notification - Check Firebase Console to send real push notifications',
    );
  }
}
