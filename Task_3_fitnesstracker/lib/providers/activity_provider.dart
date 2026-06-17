import 'package:flutter/material.dart';
import '../models/activity_model.dart';
import '../services/database_service.dart';
import '../utils/constants.dart';

class ActivityProvider extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();

  List<ActivityModel> _activities = [];
  List<ActivityModel> _filteredActivities = [];
  bool _isLoading = false;
  String _errorMessage = '';
  
  double _dailyCalories = 0.0;
  int _dailySteps = 0;
  int _dailyMinutes = 0;
  int _dailyWorkouts = 0;
  List<Map<String, dynamic>> _weeklyStats = [];
  
  String _selectedFilter = 'All';
  String _searchQuery = '';

  // Getters
  List<ActivityModel> get activities => _activities;
  List<ActivityModel> get filteredActivities => _filteredActivities;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  
  double get dailyCalories => _dailyCalories;
  int get dailySteps => _dailySteps;
  int get dailyMinutes => _dailyMinutes;
  int get dailyWorkouts => _dailyWorkouts;
  List<Map<String, dynamic>> get weeklyStats => _weeklyStats;
  
  String get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;

  // Goals
  static const double dailyStepGoal = AppConstants.dailyStepGoal;
  static const double dailyCalorieGoal = AppConstants.dailyCalorieGoal;
  static const double dailyMinuteGoal = AppConstants.dailyMinuteGoal;

  double get stepProgress {
    if (dailyStepGoal == 0) return 0.0;
    return (_dailySteps / dailyStepGoal).clamp(0.0, 1.0);
  }

  double get calorieProgress {
    if (dailyCalorieGoal == 0) return 0.0;
    return (_dailyCalories / dailyCalorieGoal).clamp(0.0, 1.0);
  }

  double get minuteProgress {
    if (dailyMinuteGoal == 0) return 0.0;
    return (_dailyMinutes / dailyMinuteGoal).clamp(0.0, 1.0);
  }

  ActivityProvider() {
    loadActivities();
  }

  Future<void> loadActivities() async {
    _isLoading = true;
    _errorMessage = '';
    // Use notifyListeners() after setting loading to true, but we should not do it inside constructor if called synchronously.
    // However, since loadActivities is async, we can notify safely.
    notifyListeners();
    try {
      _activities = await _dbService.getAllActivities();
      _calculateDailyStats();
      await loadWeeklyStats();
      
      // Keep active filter or query intact if possible
      if (_selectedFilter != 'All') {
        _filteredActivities = _activities.where((a) => a.exerciseType == _selectedFilter).toList();
      } else if (_searchQuery.isNotEmpty) {
        _filteredActivities = await _dbService.searchActivities(_searchQuery);
      } else {
        _filteredActivities = List.from(_activities);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addActivity(ActivityModel activity, {VoidCallback? onSuccess}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _dbService.insertActivity(activity);
      await loadActivities();
      if (onSuccess != null) {
        onSuccess();
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateActivity(ActivityModel activity) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _dbService.updateActivity(activity);
      await loadActivities();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteActivity(int id) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _dbService.deleteActivity(id);
      await loadActivities();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearAllData() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      await _dbService.clearAllData();
      await loadActivities();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void _calculateDailyStats() {
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    final todayActivities = _activities.where((a) {
      return a.createdAt.toIso8601String().substring(0, 10) == todayStr;
    }).toList();

    _dailyCalories = 0.0;
    _dailySteps = 0;
    _dailyMinutes = 0;
    _dailyWorkouts = todayActivities.length;

    for (var a in todayActivities) {
      _dailyCalories += a.caloriesBurned;
      _dailySteps += a.steps;
      _dailyMinutes += a.durationMinutes;
    }
  }

  Future<void> loadWeeklyStats() async {
    try {
      _weeklyStats = await _dbService.getWeeklyStats();
    } catch (e) {
      _errorMessage = e.toString();
    }
  }

  void filterByType(String type) {
    _selectedFilter = type;
    _searchQuery = '';
    if (type == 'All') {
      _filteredActivities = List.from(_activities);
    } else {
      _filteredActivities = _activities.where((a) => a.exerciseType == type).toList();
    }
    notifyListeners();
  }

  Future<void> searchActivities(String query) async {
    _searchQuery = query;
    _selectedFilter = 'All';
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      if (query.trim().isEmpty) {
        _filteredActivities = List.from(_activities);
      } else {
        _filteredActivities = await _dbService.searchActivities(query);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearFilter() {
    _selectedFilter = 'All';
    _searchQuery = '';
    _filteredActivities = List.from(_activities);
    notifyListeners();
  }

  void clearErrorMessage() {
    _errorMessage = '';
    notifyListeners();
  }
}
