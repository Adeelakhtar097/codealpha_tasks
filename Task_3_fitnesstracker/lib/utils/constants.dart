class AppConstants {
  static const double dailyStepGoal = 10000;
  static const double dailyCalorieGoal = 600;
  static const double dailyMinuteGoal = 60;
  
  static const String dbName = 'fitness_tracker.db';
  static const String tableActivities = 'activities';
  
  static const List<String> exerciseTypes = [
    'Running',
    'Walking',
    'Cycling',
    'Gym',
    'Yoga',
    'Swimming',
    'Cardio',
    'Strength Training',
    'Other',
  ];
  
  static const List<String> filterOptions = [
    'All',
    'Running',
    'Walking',
    'Cycling',
    'Gym',
    'Yoga',
    'Swimming',
    'Other',
  ];
}
