class Budget {
  final String id;
  final String userId;
  final double totalAmount;
  final Map<String, double> allocations;
  final DateTime startDate;
  final DateTime endDate;

  Budget({
    required this.id,
    required this.userId,
    required this.totalAmount,
    required this.allocations,
    required this.startDate,
    required this.endDate,
  });

  Budget copyWith({
    String? id,
    String? userId,
    double? totalAmount,
    Map<String, double>? allocations,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Budget(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      totalAmount: totalAmount ?? this.totalAmount,
      allocations: allocations ?? this.allocations,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'totalAmount': totalAmount,
      'allocations': allocations,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'] as String,
      userId: json['userId'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      allocations: Map<String, double>.from(json['allocations'] as Map),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Budget &&
      other.id == id &&
      other.userId == userId &&
      other.totalAmount == totalAmount &&
      other.allocations == allocations &&
      other.startDate == startDate &&
      other.endDate == endDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userId.hashCode ^
      totalAmount.hashCode ^
      allocations.hashCode ^
      startDate.hashCode ^
      endDate.hashCode;
  }
}