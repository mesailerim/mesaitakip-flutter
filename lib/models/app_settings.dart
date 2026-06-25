import 'dart:convert';

class AppSettings {
  final String userId;
  final String email;
  final String firstName;
  final String lastName;
  final String workplaceName;
  final String birthDate;
  final String hireDate;
  final double grossSalary;
  final double taxPercentage;
  final double netSalary;
  final double hourlyWage;
  final String currency;
  final String language;
  final String isDarkMode;
  final bool isPinEnabled;
  final String pinCode;
  final int themeColor;
  final int annualLeaveBalance;
  final int usedLeaveDays;
  final String maritalStatus;
  final String gender;
  final bool isSpouseWorking;
  final int childrenCount;
  final bool isSalaryHidden;
  final bool hasCompletedOnboarding;
  final int lastSyncTime;
  final String e2eKey;
  final bool autoReminders;
  final String linkedinUrl;
  final String portfolioUrl;
  final String careerSummary;

  const AppSettings({
    this.userId = '',
    this.email = '',
    this.firstName = '',
    this.lastName = '',
    this.workplaceName = '',
    this.birthDate = '',
    this.hireDate = '',
    this.grossSalary = 0.0,
    this.taxPercentage = 0.0,
    this.netSalary = 0.0,
    this.hourlyWage = 0.0,
    this.currency = '₺',
    this.language = 'tr',
    this.isDarkMode = 'auto',
    this.isPinEnabled = false,
    this.pinCode = '',
    this.themeColor = 0xFF65558F,
    this.annualLeaveBalance = 14,
    this.usedLeaveDays = 0,
    this.maritalStatus = 'Bekar',
    this.gender = 'Belirtilmedi',
    this.isSpouseWorking = false,
    this.childrenCount = 0,
    this.isSalaryHidden = false,
    this.hasCompletedOnboarding = false,
    this.lastSyncTime = 0,
    this.e2eKey = '',
    this.autoReminders = false,
    this.linkedinUrl = '',
    this.portfolioUrl = '',
    this.careerSummary = '',
  });

  AppSettings copyWith({
    String? userId,
    String? email,
    String? firstName,
    String? lastName,
    String? workplaceName,
    String? birthDate,
    String? hireDate,
    double? grossSalary,
    double? taxPercentage,
    double? netSalary,
    double? hourlyWage,
    String? currency,
    String? language,
    String? isDarkMode,
    bool? isPinEnabled,
    String? pinCode,
    int? themeColor,
    int? annualLeaveBalance,
    int? usedLeaveDays,
    String? maritalStatus,
    String? gender,
    bool? isSpouseWorking,
    int? childrenCount,
    bool? isSalaryHidden,
    bool? hasCompletedOnboarding,
    int? lastSyncTime,
    String? e2eKey,
    bool? autoReminders,
    String? linkedinUrl,
    String? portfolioUrl,
    String? careerSummary,
  }) {
    return AppSettings(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      workplaceName: workplaceName ?? this.workplaceName,
      birthDate: birthDate ?? this.birthDate,
      hireDate: hireDate ?? this.hireDate,
      grossSalary: grossSalary ?? this.grossSalary,
      taxPercentage: taxPercentage ?? this.taxPercentage,
      netSalary: netSalary ?? this.netSalary,
      hourlyWage: hourlyWage ?? this.hourlyWage,
      currency: currency ?? this.currency,
      language: language ?? this.language,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isPinEnabled: isPinEnabled ?? this.isPinEnabled,
      pinCode: pinCode ?? this.pinCode,
      themeColor: themeColor ?? this.themeColor,
      annualLeaveBalance: annualLeaveBalance ?? this.annualLeaveBalance,
      usedLeaveDays: usedLeaveDays ?? this.usedLeaveDays,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      gender: gender ?? this.gender,
      isSpouseWorking: isSpouseWorking ?? this.isSpouseWorking,
      childrenCount: childrenCount ?? this.childrenCount,
      isSalaryHidden: isSalaryHidden ?? this.isSalaryHidden,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      e2eKey: e2eKey ?? this.e2eKey,
      autoReminders: autoReminders ?? this.autoReminders,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      portfolioUrl: portfolioUrl ?? this.portfolioUrl,
      careerSummary: careerSummary ?? this.careerSummary,
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'workplaceName': workplaceName,
        'birthDate': birthDate,
        'hireDate': hireDate,
        'grossSalary': grossSalary,
        'taxPercentage': taxPercentage,
        'netSalary': netSalary,
        'hourlyWage': hourlyWage,
        'currency': currency,
        'language': language,
        'isDarkMode': isDarkMode,
        'isPinEnabled': isPinEnabled,
        'pinCode': pinCode,
        'themeColor': themeColor,
        'annualLeaveBalance': annualLeaveBalance,
        'usedLeaveDays': usedLeaveDays,
        'maritalStatus': maritalStatus,
        'gender': gender,
        'isSpouseWorking': isSpouseWorking,
        'childrenCount': childrenCount,
        'isSalaryHidden': isSalaryHidden,
        'hasCompletedOnboarding': hasCompletedOnboarding,
        'lastSyncTime': lastSyncTime,
        'e2eKey': e2eKey,
        'autoReminders': autoReminders,
        'linkedinUrl': linkedinUrl,
        'portfolioUrl': portfolioUrl,
        'careerSummary': careerSummary,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        userId: (json['userId'] as String?) ?? '',
        email: (json['email'] as String?) ?? '',
        firstName: (json['firstName'] as String?) ?? '',
        lastName: (json['lastName'] as String?) ?? '',
        workplaceName: (json['workplaceName'] as String?) ?? '',
        birthDate: (json['birthDate'] as String?) ?? '',
        hireDate: (json['hireDate'] as String?) ?? '',
        grossSalary: (json['grossSalary'] as num?)?.toDouble() ?? 0.0,
        taxPercentage: (json['taxPercentage'] as num?)?.toDouble() ?? 0.0,
        netSalary: (json['netSalary'] as num?)?.toDouble() ?? 0.0,
        hourlyWage: (json['hourlyWage'] as num?)?.toDouble() ?? 0.0,
        currency: (json['currency'] as String?) ?? '₺',
        language: (json['language'] as String?) ?? 'tr',
        isDarkMode: (json['isDarkMode'] as String?) ?? 'auto',
        isPinEnabled: (json['isPinEnabled'] as bool?) ?? false,
        pinCode: (json['pinCode'] as String?) ?? '',
        themeColor: (json['themeColor'] as int?) ?? 0xFF65558F,
        annualLeaveBalance: (json['annualLeaveBalance'] as int?) ?? 14,
        usedLeaveDays: (json['usedLeaveDays'] as int?) ?? 0,
        maritalStatus: (json['maritalStatus'] as String?) ?? 'Bekar',
        gender: (json['gender'] as String?) ?? 'Belirtilmedi',
        isSpouseWorking: (json['isSpouseWorking'] as bool?) ?? false,
        childrenCount: (json['childrenCount'] as int?) ?? 0,
        isSalaryHidden: (json['isSalaryHidden'] as bool?) ?? false,
        hasCompletedOnboarding:
            (json['hasCompletedOnboarding'] as bool?) ?? false,
        lastSyncTime: (json['lastSyncTime'] as int?) ?? 0,
        e2eKey: (json['e2eKey'] as String?) ?? '',
        autoReminders: (json['autoReminders'] as bool?) ?? false,
        linkedinUrl: (json['linkedinUrl'] as String?) ?? '',
        portfolioUrl: (json['portfolioUrl'] as String?) ?? '',
        careerSummary: (json['careerSummary'] as String?) ?? '',
      );

  String toJsonString() => jsonEncode(toJson());

  factory AppSettings.fromJsonString(String jsonStr) =>
      AppSettings.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);

  String get fullName => '$firstName $lastName'.trim();
}
