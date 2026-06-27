import 'package:flutter/material.dart';
import 'package:autozy_vendor_app/data/models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onAcknowledge;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onAcknowledge,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (notification.type.toUpperCase()) {
      case "SYSTEM":
        icon = Icons.info_outline;
        color = Colors.blue;
        break;
      case "SLA_BREACH":
      case "FRAUD":
        icon = Icons.flag;
        color = Colors.red;
        break;
      case "SUCCESS":
        icon = Icons.check_circle_outline;
        color = Colors.green;
        break;
      default:
        icon = Icons.notifications_none;
        color = Colors.orange;
    }

    String formattedDate = '';
    try {
      final parsedDate = DateTime.parse(notification.createdAt).toLocal();
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final day = parsedDate.day.toString().padLeft(2, '0');
      final month = months[parsedDate.month - 1];
      final year = parsedDate.year;
      
      int hour = parsedDate.hour;
      final isPm = hour >= 12;
      final period = isPm ? 'PM' : 'AM';
      if (hour > 12) {
        hour -= 12;
      } else if (hour == 0) {
        hour = 12;
      }
      final hourStr = hour.toString().padLeft(2, '0');
      final minute = parsedDate.minute.toString().padLeft(2, '0');
      
      formattedDate = '$day $month $year, $hourStr:$minute $period';
    } catch (e) {
      formattedDate = notification.createdAt;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.white : const Color(0xfff0f7ff),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: notification.isRead ? const Color(0xffe9e9e9) : const Color(0xffd0e5ff),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w700,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification.body,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!notification.isRead)
            InkWell(
              onTap: onAcknowledge,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xffe0eeff)),
                  ),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.done_all, color: Colors.blue, size: 16),
                      SizedBox(width: 6),
                      Text(
                        "Mark as Read",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
