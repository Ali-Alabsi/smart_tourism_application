class NotificationEntity {
  final int id;
  final String title;
  final String type;
  final int? typeId;
  final String details;
  final String icon;
  final bool isActive;
  final String? scheduledAt;
  final String createdAt;
  final String updatedAt;
  final NotificationPivot pivot;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.type,
    required this.typeId,
    required this.details,
    required this.icon,
    required this.isActive,
    required this.scheduledAt,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
  });

  factory NotificationEntity.fromJson(Map<String, dynamic> json) {
    return NotificationEntity(
      id: json['id'] as int,
      title: json['title'] as String,
      type: json['type'] as String,
      typeId: json['type_id'] as int?,
      details: json['details'] as String,
      icon: json['icon'] as String,
      isActive: json['is_active'] as bool,
      scheduledAt: json['scheduled_at'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      pivot: NotificationPivot.fromJson(json['pivot'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'type_id': typeId,
      'details': details,
      'icon': icon,
      'is_active': isActive,
      'scheduled_at': scheduledAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'pivot': pivot.toJson(),
    };
  }
}

class NotificationPivot {
  final int userId;
  final int notificationId;
  final int isRead;
  final String? readAt;
  final String createdAt;
  final String updatedAt;

  NotificationPivot({
    required this.userId,
    required this.notificationId,
    required this.isRead,
    required this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationPivot.fromJson(Map<String, dynamic> json) {
    return NotificationPivot(
      userId: json['user_id'] as int,
      notificationId: json['notification_id'] as int,
      isRead: json['is_read'] as int,
      readAt: json['read_at'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'notification_id': notificationId,
      'is_read': isRead,
      'read_at': readAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}