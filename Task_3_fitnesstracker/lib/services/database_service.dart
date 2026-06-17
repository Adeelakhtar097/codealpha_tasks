import 'package:sqflite/sqflite.dart';
import '../database/sqlite_database.dart';
import '../models/activity_model.dart';
import '../utils/constants.dart';

class DatabaseService {
  Future<int> insertActivity(ActivityModel activity) async {
    try {
      final db = await SQLiteDatabase.instance.database;
      return await db.insert(
        AppConstants.tableActivities,
        activity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Failed to insert activity: $e');
    }
  }

  Future<List<ActivityModel>> getAllActivities() async {
    try {
      final db = await SQLiteDatabase.instance.database;
      final maps = await db.query(
        AppConstants.tableActivities,
        orderBy: 'createdAt DESC',
      );
      return maps.map((map) => ActivityModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to load all activities: $e');
    }
  }

  Future<List<ActivityModel>> getActivitiesByDate(DateTime date) async {
    try {
      final db = await SQLiteDatabase.instance.database;
      final dateStr = date.toIso8601String().substring(0, 10);
      final maps = await db.query(
        AppConstants.tableActivities,
        where: 'createdAt LIKE ?',
        whereArgs: ['$dateStr%'],
        orderBy: 'createdAt DESC',
      );
      return maps.map((map) => ActivityModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to load activities by date: $e');
    }
  }

  Future<List<ActivityModel>> getActivitiesByDateRange(DateTime start, DateTime end) async {
    try {
      final db = await SQLiteDatabase.instance.database;
      final startStr = start.toIso8601String();
      final endStr = end.toIso8601String();
      final maps = await db.query(
        AppConstants.tableActivities,
        where: 'createdAt BETWEEN ? AND ?',
        whereArgs: [startStr, endStr],
        orderBy: 'createdAt DESC',
      );
      return maps.map((map) => ActivityModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to load activities in date range: $e');
    }
  }

  Future<int> updateActivity(ActivityModel activity) async {
    try {
      if (activity.id == null) {
        throw Exception('Cannot update activity without an ID');
      }
      final db = await SQLiteDatabase.instance.database;
      return await db.update(
        AppConstants.tableActivities,
        activity.toMap(),
        where: 'id = ?',
        whereArgs: [activity.id],
      );
    } catch (e) {
      throw Exception('Failed to update activity: $e');
    }
  }

  Future<int> deleteActivity(int id) async {
    try {
      final db = await SQLiteDatabase.instance.database;
      return await db.delete(
        AppConstants.tableActivities,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to delete activity: $e');
    }
  }

  Future<void> clearAllData() async {
    try {
      final db = await SQLiteDatabase.instance.database;
      await db.delete(AppConstants.tableActivities);
    } catch (e) {
      throw Exception('Failed to clear database data: $e');
    }
  }

  Future<Map<String, dynamic>> getTodayStats() async {
    try {
      final db = await SQLiteDatabase.instance.database;
      final dateStr = DateTime.now().toIso8601String().substring(0, 10);
      final results = await db.query(
        AppConstants.tableActivities,
        where: 'createdAt LIKE ?',
        whereArgs: ['$dateStr%'],
      );

      double totalCalories = 0.0;
      int totalSteps = 0;
      int totalMinutes = 0;
      int workoutCount = results.length;

      for (var row in results) {
        totalCalories += (row['caloriesBurned'] as num).toDouble();
        totalSteps += row['steps'] as int? ?? 0;
        totalMinutes += row['durationMinutes'] as int? ?? 0;
      }

      return {
        'totalCalories': totalCalories,
        'totalSteps': totalSteps,
        'totalMinutes': totalMinutes,
        'workoutCount': workoutCount,
      };
    } catch (e) {
      throw Exception('Failed to fetch today\'s stats: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getWeeklyStats() async {
    try {
      final db = await SQLiteDatabase.instance.database;
      final List<Map<String, dynamic>> weekly = [];
      final now = DateTime.now();

      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final dateStr = date.toIso8601String().substring(0, 10);
        
        final results = await db.query(
          AppConstants.tableActivities,
          where: 'createdAt LIKE ?',
          whereArgs: ['$dateStr%'],
        );

        double totalCalories = 0.0;
        int totalSteps = 0;
        int totalMinutes = 0;
        int workoutCount = results.length;

        for (var row in results) {
          totalCalories += (row['caloriesBurned'] as num).toDouble();
          totalSteps += row['steps'] as int? ?? 0;
          totalMinutes += row['durationMinutes'] as int? ?? 0;
        }

        weekly.add({
          'date': dateStr,
          'totalCalories': totalCalories,
          'totalSteps': totalSteps,
          'totalMinutes': totalMinutes,
          'workoutCount': workoutCount,
        });
      }

      return weekly;
    } catch (e) {
      throw Exception('Failed to fetch weekly stats: $e');
    }
  }

  Future<List<ActivityModel>> searchActivities(String query) async {
    try {
      final db = await SQLiteDatabase.instance.database;
      final maps = await db.query(
        AppConstants.tableActivities,
        where: 'exerciseType LIKE ? OR notes LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
        orderBy: 'createdAt DESC',
      );
      return maps.map((map) => ActivityModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to search activities: $e');
    }
  }
}
