import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/app_settings.dart';
import '../models/overtime_log.dart';
import '../models/absent_day.dart';
import '../models/work_experience.dart';
import '../services/supabase_service.dart';

class AppState {
  final AppSettings settings;
  final List<OvertimeLog> logs;
  final List<AbsentDay> absentDays;
  final List<WorkExperience> workExperiences;
  final bool isLoading;
  final int selectedMonth; // 1-12
  final int selectedYear;
  final String? error;

  const AppState({
    this.settings = const AppSettings(),
    this.logs = const [],
    this.absentDays = const [],
    this.workExperiences = const [],
    this.isLoading = false,
    this.selectedMonth = 6,
    this.selectedYear = 2026,
    this.error,
  });

  AppState copyWith({
    AppSettings? settings,
    List<OvertimeLog>? logs,
    List<AbsentDay>? absentDays,
    List<WorkExperience>? workExperiences,
    bool? isLoading,
    int? selectedMonth,
    int? selectedYear,
    String? error,
  }) {
    return AppState(
      settings: settings ?? this.settings,
      logs: logs ?? this.logs,
      absentDays: absentDays ?? this.absentDays,
      workExperiences: workExperiences ?? this.workExperiences,
      isLoading: isLoading ?? this.isLoading,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
      error: error,
    );
  }
}

class AppNotifier extends StateNotifier<AppState> {
  AppNotifier() : super(AppState(
    selectedMonth: DateTime.now().month,
    selectedYear: DateTime.now().year,
  )) {
    loadAll();
  }

  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true);
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load settings
      final settingsStr = prefs.getString('app_settings');
      AppSettings settings = const AppSettings();
      if (settingsStr != null) {
        settings = AppSettings.fromJsonString(settingsStr);
      }

      // Load logs
      final logsStr = prefs.getString('overtime_logs');
      List<OvertimeLog> logs = [];
      if (logsStr != null) {
        final List decoded = jsonDecode(logsStr);
        logs = decoded.map((e) => OvertimeLog.fromJson(e)).toList();
      }

      // Load absent days
      final absentStr = prefs.getString('absent_days');
      List<AbsentDay> absentDays = [];
      if (absentStr != null) {
        final List decoded = jsonDecode(absentStr);
        absentDays = decoded.map((e) => AbsentDay.fromJson(e)).toList();
      }

      // Load work experiences
      final expStr = prefs.getString('work_experiences');
      List<WorkExperience> workExperiences = [];
      if (expStr != null) {
        final List decoded = jsonDecode(expStr);
        workExperiences = decoded.map((e) => WorkExperience.fromJson(e)).toList();
      }

      state = state.copyWith(
        settings: settings,
        logs: logs,
        absentDays: absentDays,
        workExperiences: workExperiences,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_settings', state.settings.toJsonString());
    await prefs.setString('overtime_logs', jsonEncode(state.logs.map((e) => e.toJson()).toList()));
    await prefs.setString('absent_days', jsonEncode(state.absentDays.map((e) => e.toJson()).toList()));
    await prefs.setString('work_experiences', jsonEncode(state.workExperiences.map((e) => e.toJson()).toList()));
  }

  Future<void> saveSettings(AppSettings settings) async {
    state = state.copyWith(settings: settings);
    await _saveToPrefs();
  }

  Future<void> loginAsGuest() async {
    final userId = const Uuid().v4();
    final settings = state.settings.copyWith(userId: userId);
    await saveSettings(settings);
  }

  Future<void> linkAccount(String email, String firstName, String lastName) async {
    final settings = state.settings.copyWith(
      userId: email,
      email: email,
      firstName: firstName,
      lastName: lastName,
    );
    await saveSettings(settings);
  }

  Future<void> completeOnboarding({
    required String fullName,
    required String workplaceName,
    required String birthDate,
    required String hireDate,
    required double grossSalary,
    required double taxPercentage,
    required int annualLeaveBalance,
    required String maritalStatus,
    required String gender,
  }) async {
    final parts = fullName.trim().split(' ');
    final first = parts.firstOrNull ?? '';
    final last = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    
    // Brüt Maaş / 225 kuralı
    final hourlyWage = grossSalary > 0 ? (grossSalary / 225.0) : state.settings.hourlyWage;

    final settings = state.settings.copyWith(
      firstName: first,
      lastName: last,
      workplaceName: workplaceName,
      birthDate: birthDate,
      hireDate: hireDate,
      grossSalary: grossSalary,
      taxPercentage: taxPercentage,
      hourlyWage: hourlyWage,
      annualLeaveBalance: annualLeaveBalance,
      maritalStatus: maritalStatus,
      gender: gender,
      hasCompletedOnboarding: true,
    );
    await saveSettings(settings);
  }

  Future<void> addOvertimeLog(OvertimeLog log) async {
    final updated = [...state.logs, log];
    state = state.copyWith(logs: updated);
    await _saveToPrefs();
  }

  Future<void> updateOvertimeLog(OvertimeLog log) async {
    final updated = state.logs.map((e) => e.id == log.id ? log : e).toList();
    state = state.copyWith(logs: updated);
    await _saveToPrefs();
  }

  Future<void> deleteOvertimeLog(String id) async {
    final updated = state.logs.where((e) => e.id != id).toList();
    state = state.copyWith(logs: updated);
    await _saveToPrefs();
  }

  Future<void> addAbsentDay(AbsentDay day) async {
    final updated = [...state.absentDays, day];
    state = state.copyWith(absentDays: updated);
    await _saveToPrefs();
  }

  Future<void> deleteAbsentDay(String id) async {
    final updated = state.absentDays.where((e) => e.id != id).toList();
    state = state.copyWith(absentDays: updated);
    await _saveToPrefs();
  }

  Future<void> addWorkExperience(WorkExperience exp) async {
    final updated = [...state.workExperiences, exp];
    state = state.copyWith(workExperiences: updated);
    await _saveToPrefs();
  }

  Future<void> updateWorkExperience(WorkExperience exp) async {
    final updated = state.workExperiences.map((e) => e.id == exp.id ? exp : e).toList();
    state = state.copyWith(workExperiences: updated);
    await _saveToPrefs();
  }

  Future<void> deleteWorkExperience(String id) async {
    final updated = state.workExperiences.where((e) => e.id != id).toList();
    state = state.copyWith(workExperiences: updated);
    await _saveToPrefs();
  }

  void selectMonth(int month, int year) {
    state = state.copyWith(selectedMonth: month, selectedYear: year);
  }

  Future<void> performCloudSync() async {
    state = state.copyWith(isLoading: true);
    try {
      final userId = state.settings.userId;
      if (userId.isEmpty) return;

      await SupabaseService.upsertLogs(state.logs);
      await SupabaseService.upsertAbsentDays(state.absentDays);
      await SupabaseService.upsertWorkExperiences(state.workExperiences);
      await SupabaseService.upsertUserSettings(userId, state.settings.toJson());

      final updatedSettings = state.settings.copyWith(lastSyncTime: DateTime.now().millisecondsSinceEpoch);
      state = state.copyWith(settings: updatedSettings, isLoading: false);
      await _saveToPrefs();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> resetApp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    state = const AppState();
  }
}

final appProvider = StateNotifierProvider<AppNotifier, AppState>((ref) => AppNotifier());
