class AbsentDay {
  final String id;
  final String userId;
  final String dateStr; // YYYY-MM-DD
  final String reason;

  const AbsentDay({
    required this.id,
    required this.userId,
    required this.dateStr,
    this.reason = '',
  });

  AbsentDay copyWith({
    String? id,
    String? userId,
    String? dateStr,
    String? reason,
  }) {
    return AbsentDay(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dateStr: dateStr ?? this.dateStr,
      reason: reason ?? this.reason,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'dateStr': dateStr,
        'reason': reason,
      };

  factory AbsentDay.fromJson(Map<String, dynamic> json) => AbsentDay(
        id: (json['id'] as String?) ?? '',
        userId: (json['userId'] as String?) ?? '',
        dateStr: (json['dateStr'] as String?) ?? '',
        reason: (json['reason'] as String?) ?? '',
      );
}
