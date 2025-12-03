import 'package:flutter/material.dart';
import 'package:smart_tourism_application/core/theme/app_colors.dart';
import 'package:smart_tourism_application/presentation/widgets/custom_app_bar.dart';
import 'package:smart_tourism_application/presentation/controllers/notifications_controller.dart';
import 'package:provider/provider.dart';
import 'package:smart_tourism_application/core/entities/notification.dart';
import 'package:get_it/get_it.dart';

class NotificationsListView extends StatelessWidget {
  const NotificationsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NotificationsController(GetIt.instance())..loadNotifications(),
      child: Consumer<NotificationsController>(
        builder: (context, controller, child) {
          return Scaffold(
            appBar: CustomAppBar(
              title: 'Notifications',
            ),
            body: controller.isLoading
                ? Center(child: CircularProgressIndicator())
                : controller.errorMessage != null
                    ? Center(child: Text('Error: ${controller.errorMessage}'))
                    : Column(
                        children: [
                          // Notification Filters
                          _buildNotificationFilters(),
                          
                          // Notification List
                          Expanded(
                            child: _buildNotificationList(context, controller.notifications),
                          ),
                        ],
                      ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationFilters() {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _FilterChip(
            label: 'All',
            isSelected: true,
          ),
          _FilterChip(
            label: 'Bookings',
            isSelected: false,
          ),
          _FilterChip(
            label: 'Promotions',
            isSelected: false,
          ),
          _FilterChip(
            label: 'Updates',
            isSelected: false,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(BuildContext context, List<NotificationEntity> notifications) {
    return RefreshIndicator(
      onRefresh: () async {
        final controller = Provider.of<NotificationsController>(context, listen: false);
        await controller.loadNotifications();
      },
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        children: notifications.map((notification) {
          return _NotificationItem(
            context: context,
            notification: notification,
          );
        }).toList(),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primary,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final BuildContext context;
  final NotificationEntity notification;

  const _NotificationItem({
    required this.context,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final isUnread = notification.pivot.isRead == 0;
    final iconData = _getIconData(notification.icon);
    final iconColor = _getIconColor(notification.type);
    
    return Card(
      margin: EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: isUnread ? 2 : 1,
      child: ListTile(
        contentPadding: EdgeInsets.all(12.0),
        leading: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            iconData,
            color: iconColor,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: TextStyle(
                  fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isUnread)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              notification.details,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4),
            Text(
              _formatDate(notification.createdAt),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: () {
          // Mark as read and show notification content in a dialog
          final controller = Provider.of<NotificationsController>(context, listen: false);
          if (isUnread) {
            controller.markAsRead(notification.id);
          }
          _showNotificationDialog(context, notification, iconData, iconColor);
        },
      ),
    );
  }

  void _showNotificationDialog(BuildContext context, NotificationEntity notification, IconData iconData, Color iconColor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  color: iconColor,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  notification.title,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.details,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                _formatDate(notification.createdAt),
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  IconData _getIconData(String icon) {
    // Map font awesome icons to material icons
    switch (icon) {
      case 'fas fa-handshake':
        return Icons.handshake;
      case 'fas fa-hotel':
        return Icons.hotel;
      case 'fas fa-utensils':
        return Icons.restaurant;
      case 'fas fa-calendar-check':
        return Icons.calendar_today;
      case 'fas fa-lightbulb':
        return Icons.lightbulb;
      case 'fas fa-plane':
        return Icons.flight;
      case 'fas fa-location-arrow':
        return Icons.location_on;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'welcome':
        return Colors.blue;
      case 'hotel':
        return Colors.green;
      case 'restaurant':
        return Colors.orange;
      case 'activity':
        return Colors.purple;
      case 'tip':
        return Colors.teal;
      case 'flight':
        return Colors.indigo;
      default:
        return AppColors.primary;
    }
  }

  String _formatDate(String date) {
    final dateTime = DateTime.parse(date);
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}