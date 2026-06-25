class WorkExperience {
  final String id;
  final String userId;
  final String companyName;
  final String jobTitle;
  final String startDate;
  final String endDate;
  final String description;
  final String achievements;

  const WorkExperience({
    required this.id,
    required this.userId,
    required this.companyName,
    required this.jobTitle,
    required this.startDate,
    required this.endDate,
    this.description = '',
    this.achievements = '',
  });

  WorkExperience copyWith({
    String? id,
    String? userId,
    String? companyName,
    String? jobTitle,
    String? startDate,
    String? endDate,
    String? description,
    String? achievements,
  }) {
    return WorkExperience(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      companyName: companyName ?? this.companyName,
      jobTitle: jobTitle ?? this.jobTitle,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      achievements: achievements ?? this.achievements,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'companyName': companyName,
        'jobTitle': jobTitle,
        'startDate': startDate,
        'endDate': endDate,
        'description': description,
        'achievements': achievements,
      };

  factory WorkExperience.fromJson(Map<String, dynamic> json) => WorkExperience(
        id: (json['id'] as String?) ?? '',
        userId: (json['userId'] as String?) ?? '',
        companyName: (json['companyName'] as String?) ?? '',
        jobTitle: (json['jobTitle'] as String?) ?? '',
        startDate: (json['startDate'] as String?) ?? '',
        endDate: (json['endDate'] as String?) ?? '',
        description: (json['description'] as String?) ?? '',
        achievements: (json['achievements'] as String?) ?? '',
      );
}
