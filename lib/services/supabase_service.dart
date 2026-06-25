import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/overtime_log.dart';
import '../models/absent_day.dart';
import '../models/work_experience.dart';

class SupabaseService {
  static const String _supabaseUrl = 'https://mblnvbzhoybjoaeuprku.supabase.co/';
  static const String _anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1ibG52Ynpob3liam9hZXVwcmt1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA3NjkyMzEsImV4cCI6MjA2NjM0NTIzMX0.DWK9tioJoIBMFJMK9ib4E7P7vc14O1C3o4c3b3EdbhM';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: _supabaseUrl,
      publishableKey: _anonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;

  static Future<List<OvertimeLog>> fetchLogs(String userId) async {
    final response = await client
        .from('overtime_logs')
        .select()
        .eq('user_id', userId);
    return (response as List).map((json) => OvertimeLog(
      id: json['id'].toString(),
      userId: json['user_id'] as String,
      dateStr: json['date_str'] as String,
      hours: (json['hours'] as num).toDouble(),
      multiplier: (json['multiplier'] as num).toDouble(),
      hourlyWage: (json['hourly_wage'] as num).toDouble(),
      note: (json['note'] as String?) ?? '',
    )).toList();
  }

  static Future<void> upsertLogs(List<OvertimeLog> logs) async {
    if (logs.isEmpty) return;
    final data = logs.map((log) => {
      'id': log.id,
      'user_id': log.userId,
      'date_str': log.dateStr,
      'hours': log.hours,
      'multiplier': log.multiplier,
      'hourly_wage': log.hourlyWage,
      'note': log.note,
    }).toList();
    await client.from('overtime_logs').upsert(data);
  }

  static Future<void> deleteLog(String id) async {
    await client.from('overtime_logs').delete().eq('id', id);
  }

  static Future<List<AbsentDay>> fetchAbsentDays(String userId) async {
    final response = await client
        .from('absent_days')
        .select()
        .eq('user_id', userId);
    return (response as List).map((json) => AbsentDay(
      id: json['id'].toString(),
      userId: json['user_id'] as String,
      dateStr: json['date_str'] as String,
      reason: (json['reason'] as String?) ?? '',
    )).toList();
  }

  static Future<void> upsertAbsentDays(List<AbsentDay> days) async {
    if (days.isEmpty) return;
    final data = days.map((day) => {
      'id': day.id,
      'user_id': day.userId,
      'date_str': day.dateStr,
      'reason': day.reason,
    }).toList();
    await client.from('absent_days').upsert(data);
  }

  static Future<void> deleteAbsentDay(String id) async {
    await client.from('absent_days').delete().eq('id', id);
  }

  static Future<List<WorkExperience>> fetchWorkExperiences(String userId) async {
    final response = await client
        .from('work_experiences')
        .select()
        .eq('user_id', userId);
    return (response as List).map((json) => WorkExperience(
      id: json['id'].toString(),
      userId: json['user_id'] as String,
      companyName: json['company_name'] as String,
      jobTitle: json['job_title'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      description: (json['description'] as String?) ?? '',
      achievements: (json['achievements'] as String?) ?? '',
    )).toList();
  }

  static Future<void> upsertWorkExperiences(List<WorkExperience> experiences) async {
    if (experiences.isEmpty) return;
    final data = experiences.map((exp) => {
      'id': exp.id,
      'user_id': exp.userId,
      'company_name': exp.companyName,
      'job_title': exp.jobTitle,
      'start_date': exp.startDate,
      'end_date': exp.endDate,
      'description': exp.description,
      'achievements': exp.achievements,
    }).toList();
    await client.from('work_experiences').upsert(data);
  }

  static Future<void> deleteWorkExperience(String id) async {
    await client.from('work_experiences').delete().eq('id', id);
  }

  static Future<Map<String, dynamic>?> fetchUserSettings(String userId) async {
    final response = await client
        .from('user_settings')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    if (response == null) return null;
    return response['settings_json'] as Map<String, dynamic>?;
  }

  static Future<void> upsertUserSettings(String userId, Map<String, dynamic> settings) async {
    await client.from('user_settings').upsert({
      'user_id': userId,
      'settings_json': settings,
    });
  }

  static Future<bool> checkUserExists(String userId) async {
    final response = await client
        .from('overtime_logs')
        .select('id')
        .eq('user_id', userId)
        .limit(1);
    return (response as List).isNotEmpty;
  }
}
