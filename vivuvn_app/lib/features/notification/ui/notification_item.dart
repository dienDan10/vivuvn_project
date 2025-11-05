import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/model/notification.dart' as model;

class NotificationItem extends StatelessWidget {
  final model.Notification notification;
  final VoidCallback onTap;
  final VoidCallback onMarkAsRead;
  final VoidCallback onDelete;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onMarkAsRead,
    required this.onDelete,
  });

  @override
  Widget build(final BuildContext context) {
    return Dismissible(
      key: Key('notification_${notification.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.white : Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!, width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              _buildIcon(context),

              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: notification.isRead
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Message
                    Text(
                      notification.message,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Footer (time + itinerary name)
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTime(notification.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (notification.itineraryName != null) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.map, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              notification.itineraryName!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Mark as read button
              if (!notification.isRead)
                IconButton(
                  icon: const Icon(Icons.check_circle_outline),
                  color: Theme.of(context).primaryColor,
                  onPressed: onMarkAsRead,
                  tooltip: 'Mark as read',
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(final BuildContext context) {
    IconData icon;
    Color color;

    switch (notification.type) {
      case 'OwnerAnnouncement':
        icon = Icons.campaign;
        color = Colors.blue;
        break;
      case 'MemberJoined':
        icon = Icons.person_add;
        color = Colors.green;
        break;
      case 'MemberLeft':
        icon = Icons.person_remove;
        color = Colors.orange;
        break;
      case 'ItineraryUpdated':
        icon = Icons.edit;
        color = Colors.purple;
        break;
      default:
        icon = Icons.notifications;
        color = Colors.grey;
    }

    return CircleAvatar(
      backgroundColor: color.withValues(alpha: 0.1),
      child: Icon(icon, color: color, size: 24),
    );
  }

  String _formatTime(final DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('dd/MM/yyyy').format(time);
    }
  }
}
