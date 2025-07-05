import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class NotificationsScreen extends StatelessWidget {
  final List<NotificationItem> notifications = [
    NotificationItem(
      id: '1',
      title: 'New Match Found!',
      body: 'You have a 92% compatibility match with Sarah',
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
      type: NotificationType.match,
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'Message from Alex',
      body: 'Hi! I\'d love to discuss the room details with you.',
      timestamp: DateTime.now().subtract(Duration(hours: 2)),
      type: NotificationType.message,
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      title: 'Room Scan Complete',
      body: 'Your room listing has been updated with sensor data',
      timestamp: DateTime.now().subtract(Duration(hours: 5)),
      type: NotificationType.system,
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'Profile Verification',
      body: 'Your identity has been successfully verified',
      timestamp: DateTime.now().subtract(Duration(days: 1)),
      type: NotificationType.verification,
      isRead: true,
    ),
  ];

  NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              // Mark all as read
            },
            child: Text(
              'Mark All Read',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _buildNotificationCard(context, notification);
        },
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, NotificationItem notification) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getNotificationColor(notification.type),
          child: Icon(
            _getNotificationIcon(notification.type),
            color: Colors.white,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.body),
            SizedBox(height: 4),
            Text(
              _formatTimestamp(notification.timestamp),
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        trailing: !notification.isRead 
          ? Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryColor,
              ),
            )
          : null,
        onTap: () {
          // Handle notification tap
        },
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.match:
        return Colors.green;
      case NotificationType.message:
        return Colors.blue;
      case NotificationType.system:
        return Colors.orange;
      case NotificationType.verification:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.match:
        return Icons.favorite;
      case NotificationType.message:
        return Icons.message;
      case NotificationType.system:
        return Icons.settings;
      case NotificationType.verification:
        return Icons.verified;
      default:
        return Icons.notifications;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.type,
    required this.isRead,
  });
}

enum NotificationType {
  match,
  message,
  system,
  verification,
}