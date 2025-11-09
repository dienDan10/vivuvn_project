import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/routes/routes.dart';
import '../controller/notification_controller.dart';
import '../data/model/notification.dart' as model;

class NotificationItem extends ConsumerStatefulWidget {
  final model.Notification notification;

  const NotificationItem({super.key, required this.notification});

  @override
  ConsumerState<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends ConsumerState<NotificationItem> {
  void onMarkAsRead() {
    ref
        .read(notificationControllerProvider.notifier)
        .markAsRead(widget.notification.id);
  }

  void onDelete() {
    ref
        .read(notificationControllerProvider.notifier)
        .deleteNotification(widget.notification.id);
  }

  void onTap() {
    // Mark as read if unread
    if (!widget.notification.isRead) {
      ref
          .read(notificationControllerProvider.notifier)
          .markAsRead(widget.notification.id);
    }

    // Navigate to itinerary detail if itineraryId exists
    if (widget.notification.itineraryId != null) {
      context.push(
        createItineraryDetailRoute(widget.notification.itineraryId!),
      );
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Slidable(
      key: Key('notification_${widget.notification.id}'),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          if (!widget.notification.isRead)
            SlidableAction(
              onPressed: (_) => onMarkAsRead(),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.check,
              label: 'Đã đọc',
              borderRadius: BorderRadius.circular(12),
            ),
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Xóa',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.notification.isRead ? Colors.white : Colors.blue[50],
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
                      widget.notification.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: widget.notification.isRead
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Message
                    Text(
                      widget.notification.message,
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
                          _formatTime(widget.notification.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (widget.notification.itineraryName != null) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.map, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.notification.itineraryName!,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(final BuildContext context) {
    IconData icon;
    Color color;

    switch (widget.notification.type) {
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
      case 'MemberKicked':
        icon = Icons.block;
        color = Colors.red;
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
      return 'Vừa xong';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return DateFormat('dd/MM/yyyy').format(time);
    }
  }
}
