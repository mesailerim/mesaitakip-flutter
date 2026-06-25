class OvertimeLog {
  final String id;
  final String userId;
  final String dateStr; // YYYY-MM-DD
  final double hours;
  final double multiplier; // 1.5, 2.0, 3.0
  final double hourlyWage;
  final String note;

  const OvertimeLog({
    required this.id,
    required this.userId,
    required this.dateStr,
    required this.hours,
    this.multiplier = 1.5,
    required this.hourlyWage,
    this.note = '',
  });

  OvertimeLog copyWith({
    String? id,
    String? userId,
    String? dateStr,
    double? hours,
    double? multiplier,
    double? hourlyWage,
    String? note,
  }) {
    return OvertimeLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dateStr: dateStr ?? this.dateStr,
      hours: hours ?? this.hours,
      multiplier: multiplier ?? this.multiplier,
      hourlyWage: hourlyWage ?? this.hourlyWage,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'dateStr': dateStr,
        'hours': hours,
        'multiplier': multiplier,
        'hourlyWage': hourlyWage,
        'note': note,
      };

  factory OvertimeLog.fromJson(Map<String, dynamic> json) => OvertimeLog(
        id: (json['id'] as String?) ?? '',
        userId: (json['userId'] as String?) ?? '',
        dateStr: (json['dateStr'] as String?) ?? '',
        hours: (json['hours'] as num?)?.toDouble() ?? 0.0,
        multiplier: (json['multiplier'] as num?)?.toDouble() ?? 1.5,
        hourlyWage: (json['hourlyWage'] as num?)?.toDouble() ?? 0.0,
        note: (json['note'] as String?) ?? '',
      );

  double get earnings => hours * hourlyWage * multiplier;
}
