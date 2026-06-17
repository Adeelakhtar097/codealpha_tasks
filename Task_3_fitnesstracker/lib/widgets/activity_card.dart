import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/activity_model.dart';
import '../providers/activity_provider.dart';
import '../screens/add_activity_screen.dart';
import '../utils/theme.dart';

class ActivityCard extends StatelessWidget {
  final ActivityModel activity;
  final int index;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.index,
  });

  IconData _getExerciseIcon(String type) {
    switch (type) {
      case 'Running':
        return Icons.directions_run;
      case 'Walking':
        return Icons.directions_walk;
      case 'Cycling':
        return Icons.directions_bike;
      case 'Gym':
        return Icons.fitness_center;
      case 'Yoga':
        return Icons.self_improvement;
      case 'Swimming':
        return Icons.pool;
      case 'Cardio':
        return Icons.favorite;
      case 'Strength Training':
        return Icons.sports_gymnastics;
      default:
        return Icons.sports;
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Delete Activity?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              final provider = Provider.of<ActivityProvider>(context, listen: false);
              provider.deleteActivity(activity.id!).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Activity deleted'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }).catchError((e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              });
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final typeColor = AppColors.getExerciseColor(activity.exerciseType);
    final formattedDate = DateFormat('dd MMM yyyy • HH:mm').format(activity.createdAt);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Left colored icon container
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: typeColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getExerciseIcon(activity.exerciseType),
                color: typeColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            // Center info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.exerciseType,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      fontSize: 11,
                    ),
                  ),
                  if (activity.notes.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      activity.notes,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight).withOpacity(0.8),
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Right info
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${activity.caloriesBurned.toStringAsFixed(0)} kcal',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${activity.durationMinutes} min',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontSize: 12,
                  ),
                ),
                if (activity.steps > 0) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${activity.steps} steps',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
            // PopupMenu trailing
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, anim, secAnim) => AddActivityScreen(activity: activity),
                      transitionsBuilder: (context, anim, secAnim, child) => FadeTransition(
                        opacity: anim,
                        child: child,
                      ),
                    ),
                  );
                } else if (value == 'delete') {
                  _showDeleteDialog(context);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: (index * 50).ms)
        .slideX(
          begin: 0.1,
          end: 0,
          duration: 400.ms,
          curve: Curves.easeOutQuad,
          delay: (index * 50).ms,
        );
  }
}
