import 'package:flutter_test/flutter_test.dart';
import 'package:fitnesstracker/models/activity_model.dart';

void main() {
  group('ActivityModel Tests', () {
    test('ActivityModel serialization and deserialization', () {
      final now = DateTime.now();
      final activity = ActivityModel(
        id: 1,
        exerciseType: 'Running',
        durationMinutes: 30,
        caloriesBurned: 350.0,
        steps: 4500,
        notes: 'Morning jog',
        createdAt: now,
      );

      final map = activity.toMap();
      expect(map['id'], 1);
      expect(map['exerciseType'], 'Running');
      expect(map['durationMinutes'], 30);
      expect(map['caloriesBurned'], 350.0);
      expect(map['steps'], 4500);
      expect(map['notes'], 'Morning jog');
      expect(map['createdAt'], now.toIso8601String());

      final parsedActivity = ActivityModel.fromMap(map);
      expect(parsedActivity.id, 1);
      expect(parsedActivity.exerciseType, 'Running');
      expect(parsedActivity.durationMinutes, 30);
      expect(parsedActivity.caloriesBurned, 350.0);
      expect(parsedActivity.steps, 4500);
      expect(parsedActivity.notes, 'Morning jog');
      // String parsing can drop sub-millisecond precision, check string representation:
      expect(parsedActivity.createdAt.toIso8601String(), now.toIso8601String());
    });

    test('ActivityModel copyWith works correctly', () {
      final now = DateTime.now();
      final activity = ActivityModel(
        id: 1,
        exerciseType: 'Running',
        durationMinutes: 30,
        caloriesBurned: 350.0,
        steps: 4500,
        notes: 'Morning jog',
        createdAt: now,
      );

      final updated = activity.copyWith(
        exerciseType: 'Cycling',
        durationMinutes: 45,
      );

      expect(updated.id, 1);
      expect(updated.exerciseType, 'Cycling');
      expect(updated.durationMinutes, 45);
      expect(updated.caloriesBurned, 350.0); // unchanged
      expect(updated.steps, 4500); // unchanged
    });
  });
}
