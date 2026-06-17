import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/activity_provider.dart';
import '../utils/theme.dart';
import '../widgets/stat_card.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Statistics'),
          bottom: TabBar(
            labelColor: isDark ? AppColors.secondary : AppColors.primary,
            unselectedLabelColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            indicatorColor: isDark ? AppColors.secondary : AppColors.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(text: 'Weekly'),
              Tab(text: 'Monthly'),
              Tab(text: 'Overview'),
            ],
          ),
        ),
        body: Consumer<ActivityProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.activities.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return TabBarView(
              physics: const BouncingScrollPhysics(),
              children: [
                _buildWeeklyTab(context, provider, isDark, theme),
                _buildMonthlyTab(context, provider, isDark, theme),
                _buildOverviewTab(context, provider, isDark, theme),
              ],
            );
          },
        ),
      ),
    );
  }

  // ==================== WEEKLY TAB ====================
  Widget _buildWeeklyTab(BuildContext context, ActivityProvider provider, bool isDark, ThemeData theme) {
    // Helper to build Spots for Calories LineChart
    List<FlSpot> getCaloriesSpots() {
      return List.generate(provider.weeklyStats.length, (index) {
        final val = (provider.weeklyStats[index]['totalCalories'] as num? ?? 0.0).toDouble();
        return FlSpot(index.toDouble(), val);
      });
    }

    double getMaxY(List<FlSpot> spots) {
      double max = 100.0;
      for (var spot in spots) {
        if (spot.y > max) max = spot.y;
      }
      return max * 1.2;
    }

    final spots = getCaloriesSpots();
    final maxY = getMaxY(spots);

    // Helper to build Bar groups for Steps
    List<BarChartGroupData> getStepsGroups() {
      return List.generate(provider.weeklyStats.length, (index) {
        final val = (provider.weeklyStats[index]['totalSteps'] as int? ?? 0).toDouble();
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: val,
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              width: 14,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ],
        );
      });
    }

    double getMaxBarY() {
      double max = 1000.0;
      for (var stat in provider.weeklyStats) {
        final steps = (stat['totalSteps'] as int? ?? 0).toDouble();
        if (steps > max) max = steps;
      }
      return max * 1.2;
    }

    final maxBarY = getMaxBarY();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart 1: Calories Line Chart
          Text(
            'Calories Burned (kcal)',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight).withOpacity(0.1),
              ),
            ),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight).withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= 0 && idx < provider.weeklyStats.length) {
                          final dateStr = provider.weeklyStats[idx]['date'] as String;
                          final date = DateTime.parse(dateStr);
                          return Text(
                            DateFormat.E().format(date),
                            style: TextStyle(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox.shrink();
                        return Text(
                          value.toStringAsFixed(0),
                          style: TextStyle(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            fontSize: 9,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    gradient: const LinearGradient(
                      colors: [AppColors.accent, AppColors.secondary],
                    ),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accent.withOpacity(0.2),
                          AppColors.secondary.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Chart 2: Steps Bar Chart
          Text(
            'Daily Step Count',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight).withOpacity(0.1),
              ),
            ),
            child: BarChart(
              BarChartData(
                maxY: maxBarY,
                alignment: BarChartAlignment.spaceAround,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= 0 && idx < provider.weeklyStats.length) {
                          final dateStr = provider.weeklyStats[idx]['date'] as String;
                          final date = DateTime.parse(dateStr);
                          return Text(
                            DateFormat.E().format(date),
                            style: TextStyle(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox.shrink();
                        String valStr = value.toStringAsFixed(0);
                        if (value >= 1000) {
                          valStr = '${(value / 1000).toStringAsFixed(1)}k';
                        }
                        return Text(
                          valStr,
                          style: TextStyle(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            fontSize: 9,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight).withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: getStepsGroups(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== MONTHLY TAB ====================
  Widget _buildMonthlyTab(BuildContext context, ActivityProvider provider, bool isDark, ThemeData theme) {
    final now = DateTime.now();
    // Filter activities logged in current month
    final currentMonthActs = provider.activities.where((act) {
      return act.createdAt.year == now.year && act.createdAt.month == now.month;
    }).toList();

    final monthlyCalories = currentMonthActs.fold(0.0, (sum, act) => sum + act.caloriesBurned);
    final monthlyMinutes = currentMonthActs.fold(0, (sum, act) => sum + act.durationMinutes);

    // Compute weekly workout volume (last 4 weeks ending today)
    final workoutsPerWeek = List.filled(4, 0);
    for (var act in provider.activities) {
      final diffDays = now.difference(act.createdAt).inDays;
      if (diffDays >= 0 && diffDays < 28) {
        final weekIndex = diffDays ~/ 7;
        if (weekIndex < 4) {
          workoutsPerWeek[weekIndex]++;
        }
      }
    }
    // Reverse so chronologically index 0 is 3 weeks ago, index 3 is this week
    final reversedWorkouts = workoutsPerWeek.reversed.toList();
    final double maxWorkouts = (reversedWorkouts.fold(0, (max, v) => v > max ? v : max)).toDouble();
    final double maxY = maxWorkouts > 0 ? maxWorkouts * 1.3 : 5.0;

    List<BarChartGroupData> getMonthlyGroups() {
      return List.generate(reversedWorkouts.length, (index) {
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: reversedWorkouts[index].toDouble(),
              color: AppColors.accentPurple,
              width: 20,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ],
        );
      });
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Summary Row
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: 'Monthly Calories',
                  value: '${monthlyCalories.toStringAsFixed(0)} kcal',
                  icon: Icons.local_fire_department,
                  iconColor: AppColors.accent,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  label: 'Monthly Duration',
                  value: '$monthlyMinutes min',
                  icon: Icons.timer,
                  iconColor: AppColors.accentBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Workouts bar chart
          Text(
            'Workouts Logged Per Week',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight).withOpacity(0.1),
              ),
            ),
            child: BarChart(
              BarChartData(
                maxY: maxY,
                alignment: BarChartAlignment.spaceAround,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        final labels = ['Wk 4 Ago', 'Wk 3 Ago', 'Wk 2 Ago', 'This Wk'];
                        final idx = value.toInt();
                        if (idx >= 0 && idx < labels.length) {
                          return Text(
                            labels[idx],
                            style: TextStyle(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox.shrink();
                        return Text(
                          value.toStringAsFixed(0),
                          style: TextStyle(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            fontSize: 9,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight).withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: getMonthlyGroups(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== OVERVIEW TAB ====================
  Widget _buildOverviewTab(BuildContext context, ActivityProvider provider, bool isDark, ThemeData theme) {
    final activities = provider.activities;

    // Calculations
    final totalWorkouts = activities.length;
    final totalCalories = activities.fold(0.0, (sum, act) => sum + act.caloriesBurned);
    final totalMinutes = activities.fold(0, (sum, act) => sum + act.durationMinutes);

    // Most frequent workout type
    String mostFreqType = 'None';
    if (activities.isNotEmpty) {
      final counts = <String, int>{};
      for (var act in activities) {
        counts[act.exerciseType] = (counts[act.exerciseType] ?? 0) + 1;
      }
      int maxVal = 0;
      counts.forEach((k, v) {
        if (v > maxVal) {
          maxVal = v;
          mostFreqType = k;
        }
      });
    }

    // Best single-day step count
    int bestSteps = 0;
    if (activities.isNotEmpty) {
      final stepsByDay = <String, int>{};
      for (var act in activities) {
        final dateStr = act.createdAt.toIso8601String().substring(0, 10);
        stepsByDay[dateStr] = (stepsByDay[dateStr] ?? 0) + act.steps;
      }
      stepsByDay.forEach((k, v) {
        if (v > bestSteps) bestSteps = v;
      });
    }

    // Average daily calories
    double avgDailyCalories = 0.0;
    if (activities.isNotEmpty) {
      final caloriesByDay = <String, double>{};
      for (var act in activities) {
        final dateStr = act.createdAt.toIso8601String().substring(0, 10);
        caloriesByDay[dateStr] = (caloriesByDay[dateStr] ?? 0.0) + act.caloriesBurned;
      }
      double sumOfAllDays = 0.0;
      caloriesByDay.forEach((k, v) => sumOfAllDays += v);
      avgDailyCalories = sumOfAllDays / caloriesByDay.length;
    }

    // Formatted strings
    final bestStepsStr = NumberFormat.decimalPattern().format(bestSteps);
    final totalCaloriesStr = NumberFormat.decimalPattern().format(totalCalories);

    return GridView.count(
      physics: const BouncingScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.1,
      padding: const EdgeInsets.all(20),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        StatCard(
          label: 'Most Frequent Type',
          value: mostFreqType,
          icon: Icons.star,
          iconColor: AppColors.accentPurple,
        ),
        StatCard(
          label: 'Total Workouts Logged',
          value: '$totalWorkouts sessions',
          icon: Icons.fitness_center,
          iconColor: AppColors.primary,
        ),
        StatCard(
          label: 'Total Calories Burned',
          value: '$totalCaloriesStr kcal',
          icon: Icons.local_fire_department,
          iconColor: AppColors.accent,
        ),
        StatCard(
          label: 'Total Minutes',
          value: '$totalMinutes min',
          icon: Icons.timer,
          iconColor: AppColors.accentBlue,
        ),
        StatCard(
          label: 'Best Steps Day',
          value: bestStepsStr,
          icon: Icons.directions_walk,
          iconColor: Colors.green,
        ),
        StatCard(
          label: 'Average Daily Calories',
          value: '${avgDailyCalories.toStringAsFixed(0)} kcal',
          icon: Icons.flash_on,
          iconColor: Colors.amber,
        ),
      ],
    );
  }
}
