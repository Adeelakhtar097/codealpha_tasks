import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/activity_provider.dart';
import '../widgets/activity_card.dart';
import '../widgets/dashboard_chart.dart';
import '../widgets/progress_ring.dart';
import '../widgets/stat_card.dart';
import 'activity_history_screen.dart';
import 'add_activity_screen.dart';
import 'settings_screen.dart';
import 'statistics_screen.dart';
import '../utils/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedChartMetric = 'steps'; // 'steps' | 'calories' | 'duration'

  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning 💪';
    } else if (hour < 17) {
      return 'Good Afternoon 💪';
    } else {
      return 'Good Evening 💪';
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch initial activities when home screen mounts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ActivityProvider>(context, listen: false).loadActivities();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentDateStr = DateFormat('EEEE, d MMMM').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTimeBasedGreeting()),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, anim, secAnim) => const SettingsScreen(),
                  transitionsBuilder: (context, anim, secAnim, child) => FadeTransition(
                    opacity: anim,
                    child: child,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<ActivityProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.activities.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final recentActivities = provider.activities.take(3).toList();

          return RefreshIndicator(
            onRefresh: () => provider.loadActivities(),
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section 1: Today's Summary Header
                  Text(
                    "Today's Progress",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentDateStr,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section 2: Daily Goal Progress Ring
                  Center(
                    child: ProgressRing(
                      progress: provider.stepProgress,
                      centerValue: NumberFormat.decimalPattern().format(provider.dailySteps),
                      centerLabel: 'steps',
                      goalLabel: 'Goal: ${NumberFormat.decimalPattern().format(ActivityProvider.dailyStepGoal)}',
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Section 3: Stat Cards Row
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          label: 'Calories',
                          value: '${provider.dailyCalories.toStringAsFixed(0)} kcal',
                          icon: Icons.local_fire_department,
                          iconColor: AppColors.accent,
                          progress: provider.calorieProgress,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: StatCard(
                          label: 'Duration',
                          value: '${provider.dailyMinutes} min',
                          icon: Icons.timer,
                          iconColor: AppColors.accentBlue,
                          progress: provider.minuteProgress,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: StatCard(
                          label: 'Workouts',
                          value: '${provider.dailyWorkouts} done',
                          icon: Icons.fitness_center,
                          iconColor: AppColors.accentPurple,
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: 0.15, end: 0, duration: 500.ms, curve: Curves.easeOutQuad),
                  const SizedBox(height: 32),

                  // Section 4: Weekly Chart (DashboardChart widget)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "This Week",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, anim, secAnim) => const StatisticsScreen(),
                              transitionsBuilder: (context, anim, secAnim, child) => FadeTransition(
                                opacity: anim,
                                child: child,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "View All",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Metric toggle tabs for chart
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        _buildMetricTab('steps', 'Steps'),
                        _buildMetricTab('calories', 'Calories'),
                        _buildMetricTab('duration', 'Duration'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  DashboardChart(
                    weeklyStats: provider.weeklyStats,
                    chartType: _selectedChartMetric,
                  ),
                  const SizedBox(height: 32),

                  // Section 5: Recent Activities
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recent Activities",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, anim, secAnim) => const ActivityHistoryScreen(),
                              transitionsBuilder: (context, anim, secAnim, child) => FadeTransition(
                                opacity: anim,
                                child: child,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "See All",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (recentActivities.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : AppColors.cardLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight).withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.directions_run,
                            size: 48,
                            color: (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight).withOpacity(0.5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "No activities yet. Start tracking!",
                            style: TextStyle(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, anim, secAnim) => const AddActivityScreen(),
                                  transitionsBuilder: (context, anim, secAnim, child) => FadeTransition(
                                    opacity: anim,
                                    child: child,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("Add Activity"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recentActivities.length,
                      itemBuilder: (context, index) {
                        return ActivityCard(
                          activity: recentActivities[index],
                          index: index,
                        );
                      },
                    ),
                  const SizedBox(height: 48), // Padding at bottom for FAB spacing
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, anim, secAnim) => const AddActivityScreen(),
              transitionsBuilder: (context, anim, secAnim, child) => FadeTransition(
                opacity: anim,
                child: child,
              ),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Log Activity'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ).animate().scale(delay: 800.ms, duration: 400.ms, curve: Curves.bounceOut),
    );
  }

  Widget _buildMetricTab(String metric, String label) {
    final isSelected = _selectedChartMetric == metric;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedChartMetric = metric;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? AppColors.secondary : AppColors.primary)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            ),
          ),
        ),
      ),
    );
  }
}
