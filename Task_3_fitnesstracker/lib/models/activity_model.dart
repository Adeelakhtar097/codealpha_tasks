class ActivityModel {
  final int? id;
  final String exerciseType;
  final int durationMinutes;
  final double caloriesBurned;
  final int steps;
  final String notes;
  final DateTime createdAt;

  ActivityModel({
    this.id,
    required this.exerciseType,
    required this.durationMinutes,
    required this.caloriesBurned,
    this.steps = 0,
    this.notes = '',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'exerciseType': exerciseType,
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
      'steps': steps,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      id: map['id'] as int?,
      exerciseType: map['exerciseType'] as String,
      durationMinutes: map['durationMinutes'] as int,
      caloriesBurned: (map['caloriesBurned'] as num).toDouble(),
      steps: map['steps'] as int? ?? 0,
      notes: map['notes'] as String? ?? '',
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  ActivityModel copyWith({
    int? id,
    String? exerciseType,
    int? durationMinutes,
    double? caloriesBurned,
    int? steps,
    String? notes,
    DateTime? createdAt,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      exerciseType: exerciseType ?? this.exerciseType,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      steps: steps ?? this.steps,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'ActivityModel(id: $id, exerciseType: $exerciseType, durationMinutes: $durationMinutes, caloriesBurned: $caloriesBurned, steps: $steps, notes: $notes, createdAt: $createdAt)';
  }
}
