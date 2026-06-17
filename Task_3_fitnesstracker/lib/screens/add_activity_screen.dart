import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/activity_model.dart';
import '../providers/activity_provider.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';

class AddActivityScreen extends StatefulWidget {
  final ActivityModel? activity;

  const AddActivityScreen({super.key, this.activity});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedExerciseType;
  final _durationController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _stepsController = TextEditingController();
  final _notesController = TextEditingController();
  final _durationFocusNode = FocusNode();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _durationController.addListener(_onDurationChanged);
    if (widget.activity != null) {
      final act = widget.activity!;
      _selectedExerciseType = act.exerciseType;
      _durationController.text = act.durationMinutes.toString();
      _caloriesController.text = act.caloriesBurned.toStringAsFixed(0);
      _stepsController.text = act.steps > 0 ? act.steps.toString() : '';
      _notesController.text = act.notes;
      _selectedDate = act.createdAt;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _suggestDefaultWorkout();
      });
    }
  }

  @override
  void dispose() {
    _durationController.removeListener(_onDurationChanged);
    _durationController.dispose();
    _durationFocusNode.dispose();
    _caloriesController.dispose();
    _stepsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onDurationChanged() {
    if (_durationFocusNode.hasFocus) {
      _updateEstimatedCaloriesAndSteps();
    }
  }

  void _suggestDefaultWorkout() {
    final activities = Provider.of<ActivityProvider>(context, listen: false).activities;
    if (activities.isNotEmpty) {
      final counts = <String, int>{};
      final totalDurations = <String, int>{};
      for (var act in activities) {
        counts[act.exerciseType] = (counts[act.exerciseType] ?? 0) + 1;
        totalDurations[act.exerciseType] = (totalDurations[act.exerciseType] ?? 0) + act.durationMinutes;
      }
      
      String? mostFrequentType;
      int maxCount = 0;
      counts.forEach((type, count) {
        if (count > maxCount) {
          maxCount = count;
          mostFrequentType = type;
        }
      });
      
      if (mostFrequentType != null) {
        final avgDuration = (totalDurations[mostFrequentType]! / maxCount).round();
        setState(() {
          _selectedExerciseType = mostFrequentType;
          _durationController.text = avgDuration.toString();
        });
        _updateEstimatedCaloriesAndSteps();
      }
    }
  }

  void _updateEstimatedCaloriesAndSteps() {
    if (_selectedExerciseType != null && _durationController.text.trim().isNotEmpty) {
      final minutes = int.tryParse(_durationController.text.trim());
      if (minutes != null && minutes > 0) {
        // Estimate calories
        double calFactor = 4.0;
        switch (_selectedExerciseType) {
          case 'Running':
            calFactor = 10.5;
            break;
          case 'Walking':
            calFactor = 4.0;
            break;
          case 'Cycling':
            calFactor = 7.5;
            break;
          case 'Gym':
            calFactor = 5.5;
            break;
          case 'Yoga':
            calFactor = 3.0;
            break;
          case 'Swimming':
            calFactor = 8.0;
            break;
          case 'Cardio':
            calFactor = 7.0;
            break;
          case 'Strength Training':
            calFactor = 6.0;
            break;
          case 'Other':
            calFactor = 5.0;
            break;
        }
        final estimatedCalories = minutes * calFactor;
        _caloriesController.text = estimatedCalories.toStringAsFixed(0);

        // Estimate steps or step equivalents
        int stepFactor = 0;
        switch (_selectedExerciseType) {
          case 'Running':
            stepFactor = 150;
            break;
          case 'Walking':
            stepFactor = 100;
            break;
          case 'Cycling':
          case 'Gym':
          case 'Swimming':
          case 'Cardio':
          case 'Strength Training':
            stepFactor = 100; // Step Equivalent
            break;
          case 'Yoga':
            stepFactor = 60; // Step Equivalent
            break;
          case 'Other':
            stepFactor = 80; // Step Equivalent
            break;
        }
        final estimatedSteps = minutes * stepFactor;
        _stepsController.text = estimatedSteps > 0 ? estimatedSteps.toString() : '';
      }
    }
  }

  void _showCelebrationDialog(BuildContext context, List<String> goals) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: const [
              Icon(Icons.emoji_events, color: Colors.amber, size: 36),
              SizedBox(width: 8),
              Text('Goal Achieved!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Congratulations! You have reached your daily target today for:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              ...goals.map((g) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            g,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),
              const Text(
                'Keep up the amazing work! 🎉🔥',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogCtx);
                Navigator.pop(context);
              },
              child: const Text('Awesome!', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        final now = DateTime.now();
        _selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          widget.activity != null ? widget.activity!.createdAt.hour : now.hour,
          widget.activity != null ? widget.activity!.createdAt.minute : now.minute,
          widget.activity != null ? widget.activity!.createdAt.second : now.second,
        );
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final duration = int.parse(_durationController.text.trim());
      final calories = double.parse(_caloriesController.text.trim());
      final steps = _stepsController.text.trim().isNotEmpty ? int.parse(_stepsController.text.trim()) : 0;
      final notes = _notesController.text.trim();

      final provider = Provider.of<ActivityProvider>(context, listen: false);

      if (widget.activity != null) {
        // Edit flow
        final updated = widget.activity!.copyWith(
          exerciseType: _selectedExerciseType!,
          durationMinutes: duration,
          caloriesBurned: calories,
          steps: steps,
          notes: notes,
          createdAt: _selectedDate,
        );
        provider.updateActivity(updated).then((_) {
          final achievedGoals = <String>[];
          if (provider.dailySteps >= ActivityProvider.dailyStepGoal) {
            achievedGoals.add('Steps Goal (10,000 steps)');
          }
          if (provider.dailyCalories >= ActivityProvider.dailyCalorieGoal) {
            achievedGoals.add('Calorie Goal (600 kcal)');
          }
          if (provider.dailyMinutes >= ActivityProvider.dailyMinuteGoal) {
            achievedGoals.add('Duration Goal (60 mins)');
          }

          if (achievedGoals.isNotEmpty) {
            _showCelebrationDialog(context, achievedGoals);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Activity updated successfully!'),
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context);
          }
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update activity: $error'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        });
      } else {
        // Creation flow
        final newAct = ActivityModel(
          exerciseType: _selectedExerciseType!,
          durationMinutes: duration,
          caloriesBurned: calories,
          steps: steps,
          notes: notes,
          createdAt: _selectedDate,
        );
        provider.addActivity(newAct, onSuccess: () {
          final achievedGoals = <String>[];
          if (provider.dailySteps >= ActivityProvider.dailyStepGoal) {
            achievedGoals.add('Steps Goal (10,000 steps)');
          }
          if (provider.dailyCalories >= ActivityProvider.dailyCalorieGoal) {
            achievedGoals.add('Calorie Goal (600 kcal)');
          }
          if (provider.dailyMinutes >= ActivityProvider.dailyMinuteGoal) {
            achievedGoals.add('Duration Goal (60 mins)');
          }

          if (achievedGoals.isNotEmpty) {
            _showCelebrationDialog(context, achievedGoals);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Activity logged successfully!'),
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.activity != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Activity' : 'Log Activity'),
      ),
      body: Consumer<ActivityProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exercise Type Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedExerciseType,
                    decoration: const InputDecoration(
                      labelText: 'Exercise Type',
                      prefixIcon: Icon(Icons.directions_run),
                    ),
                    items: AppConstants.exerciseTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedExerciseType = val;
                      });
                      _updateEstimatedCaloriesAndSteps();
                    },
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please select an exercise type';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Duration TextFormField
                  TextFormField(
                    controller: _durationController,
                    focusNode: _durationFocusNode,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Duration (minutes)',
                      prefixIcon: Icon(Icons.timer),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please enter a duration';
                      }
                      final minutes = int.tryParse(val.trim());
                      if (minutes == null || minutes <= 0) {
                        return 'Must be a positive integer';
                      }
                      if (minutes > 1440) {
                        return 'Duration cannot exceed 1440 minutes (24h)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Calories TextFormField
                  TextFormField(
                    controller: _caloriesController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Calories Burned (kcal)',
                      prefixIcon: Icon(Icons.local_fire_department),
                      helperText: 'Auto-estimated based on duration & exercise type',
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please enter calories burned';
                      }
                      final calories = double.tryParse(val.trim());
                      if (calories == null || calories <= 0) {
                        return 'Must be a positive number';
                      }
                      if (calories > 9999) {
                        return 'Calories cannot exceed 9999 kcal';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Steps TextFormField (Optional)
                  TextFormField(
                    controller: _stepsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Steps (optional)',
                      prefixIcon: Icon(Icons.directions_walk),
                      helperText: 'Auto-calculated or step equivalent for workout',
                    ),
                    validator: (val) {
                      if (val != null && val.trim().isNotEmpty) {
                        final steps = int.tryParse(val.trim());
                        if (steps == null || steps < 0) {
                          return 'Must be a non-negative integer';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Notes TextFormField
                  TextFormField(
                    controller: _notesController,
                    keyboardType: TextInputType.text,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Notes',
                      prefixIcon: Icon(Icons.notes),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date Selection TextFormField
                  TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: DateFormat('dd MMM yyyy').format(_selectedDate),
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          label: 'Cancel',
                          outlined: true,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(
                          label: isEditing ? 'Update Activity' : 'Save Activity',
                          isLoading: provider.isLoading,
                          onPressed: _submitForm,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
