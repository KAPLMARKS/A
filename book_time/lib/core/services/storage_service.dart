import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static const String _keyTasks = 'tasks';
  static const String _keyActiveTaskId = 'active_task_id';
  static const String _keyStatistics = 'statistics';
  static const String _keyDailyFocusMinutes = 'daily_focus_minutes';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Tasks
  Future<void> saveTasks(List<Map<String, Object?>> tasks) async {
    final prefs = await _preferences;
    await prefs.setString(_keyTasks, jsonEncode(tasks));
  }

  Future<List<Map<String, Object?>>> loadTasks() async {
    final prefs = await _preferences;
    final tasksJson = prefs.getString(_keyTasks);
    if (tasksJson == null) return [];
    try {
      final Object? decoded = jsonDecode(tasksJson);
      if (decoded is! List<Object?>) return [];
      return decoded
          .whereType<Map<String, Object?>>()
          .toList(growable: false);
    } catch (_) {
      return [];
    }
  }

  Future<void> saveActiveTaskId(String? taskId) async {
    final prefs = await _preferences;
    if (taskId == null) {
      await prefs.remove(_keyActiveTaskId);
    } else {
      await prefs.setString(_keyActiveTaskId, taskId);
    }
  }

  Future<String?> loadActiveTaskId() async {
    final prefs = await _preferences;
    return prefs.getString(_keyActiveTaskId);
  }

  // Statistics
  Future<void> saveStatistics(Map<String, Object?> stats) async {
    final prefs = await _preferences;
    await prefs.setString(_keyStatistics, jsonEncode(stats));
  }

  Future<Map<String, Object?>> loadStatistics() async {
    final prefs = await _preferences;
    final statsJson = prefs.getString(_keyStatistics);
    if (statsJson == null) {
      return {
        'focusSessionsCompleted': 0,
        'totalFocusedMinutes': 0,
        'tasksCompleted': 0,
        'currentStreak': 0,
        'lastFocusDate': null,
      };
    }
    try {
      final Object? decoded = jsonDecode(statsJson);
      if (decoded is! Map<String, Object?>) {
        return {
          'focusSessionsCompleted': 0,
          'totalFocusedMinutes': 0,
          'tasksCompleted': 0,
          'currentStreak': 0,
          'lastFocusDate': null,
        };
      }
      return decoded;
    } catch (_) {
      return {
        'focusSessionsCompleted': 0,
        'totalFocusedMinutes': 0,
        'tasksCompleted': 0,
        'currentStreak': 0,
        'lastFocusDate': null,
      };
    }
  }

  Future<void> saveDailyFocusMinutes(Map<String, int> dailyMinutes) async {
    final prefs = await _preferences;
    await prefs.setString(_keyDailyFocusMinutes, jsonEncode(dailyMinutes));
  }

  Future<Map<String, int>> loadDailyFocusMinutes() async {
    final prefs = await _preferences;
    final dailyJson = prefs.getString(_keyDailyFocusMinutes);
    if (dailyJson == null) return {};
    try {
      final Object? decoded = jsonDecode(dailyJson);
      if (decoded is! Map<String, Object?>) return {};
      final result = <String, int>{};
      for (final entry in decoded.entries) {
        final value = entry.value;
        if (value is num) {
          result[entry.key] = value.toInt();
        }
      }
      return result;
    } catch (_) {
      return {};
    }
  }

  Future<void> resetAll() async {
    final prefs = await _preferences;
    await prefs.remove(_keyTasks);
    await prefs.remove(_keyActiveTaskId);
    await prefs.remove(_keyStatistics);
    await prefs.remove(_keyDailyFocusMinutes);
  }
}