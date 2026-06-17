class UserProgressModel {
  final DateTime date;
  final int totalSteps;
  final double totalCalories;
  final int totalMinutes;
  final int workoutCount;

  UserProgressModel({
    required this.date,
    required this.totalSteps,
    required this.totalCalories,
    required this.totalMinutes,
    required this.workoutCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String().substring(0, 10), // Store YYYY-MM-DD
      'totalSteps': totalSteps,
      'totalCalories': totalCalories,
      'totalMinutes': totalMinutes,
      'workoutCount': workoutCount,
    };
  }

  factory UserProgressModel.fromMap(Map<String, dynamic> map) {
    return UserProgressModel(
      date: DateTime.parse(map['date'] as String),
      totalSteps: map['totalSteps'] as int? ?? 0,
      totalCalories: (map['totalCalories'] as num?)?.toDouble() ?? 0.0,
      totalMinutes: map['totalMinutes'] as int? ?? 0,
      workoutCount: map['workoutCount'] as int? ?? 0,
    );
  }

  @override
  String toString() {
    return 'UserProgressModel(date: $date, totalSteps: $totalSteps, totalCalories: $totalCalories, totalMinutes: $totalMinutes, workoutCount: $workoutCount)';
  }
}
