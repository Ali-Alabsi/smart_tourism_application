class Booking {
  final String id;
  final String userId;
  final String destinationId;
  final DateTime startDate;
  final DateTime endDate;
  final int numberOfGuests;
  final double totalPrice;
  final String status;

  Booking({
    required this.id,
    required this.userId,
    required this.destinationId,
    required this.startDate,
    required this.endDate,
    required this.numberOfGuests,
    required this.totalPrice,
    required this.status,
  });

  Booking copyWith({
    String? id,
    String? userId,
    String? destinationId,
    DateTime? startDate,
    DateTime? endDate,
    int? numberOfGuests,
    double? totalPrice,
    String? status,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      destinationId: destinationId ?? this.destinationId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      numberOfGuests: numberOfGuests ?? this.numberOfGuests,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'destinationId': destinationId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'numberOfGuests': numberOfGuests,
      'totalPrice': totalPrice,
      'status': status,
    };
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      userId: json['userId'] as String,
      destinationId: json['destinationId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      numberOfGuests: json['numberOfGuests'] as int,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: json['status'] as String,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Booking &&
      other.id == id &&
      other.userId == userId &&
      other.destinationId == destinationId &&
      other.startDate == startDate &&
      other.endDate == endDate &&
      other.numberOfGuests == numberOfGuests &&
      other.totalPrice == totalPrice &&
      other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userId.hashCode ^
      destinationId.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      numberOfGuests.hashCode ^
      totalPrice.hashCode ^
      status.hashCode;
  }
}