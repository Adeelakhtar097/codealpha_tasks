import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/theme.dart';

class DashboardChart extends StatelessWidget {
  final List<Map<String, dynamic>> weeklyStats;
  final String chartType; // 'steps' | 'calories' | 'duration'

  const DashboardChart({
    super.key,
    required this.weeklyStats,
    required this.chartType,
  });

  double get _maxValue {
    double maxVal = 10.0;
    for (var stat in weeklyStats) {
      double val = 0;
      if (chartType == 'steps') {
        val = (stat['totalSteps'] as int? ?? 0).toDouble();
      } else if (chartType == 'calories') {
        val = (stat['totalCalories'] as num? ?? 0).toDouble();
      } else {
        val = (stat['totalMinutes'] as int? ?? 0).toDouble();
      }
      if (val > maxVal) {
        maxVal = val;
      }
    }
    return maxVal * 1.2; // Add 20% padding
  }

  List<BarChartGroupData> _buildBarGroups(BuildContext context) {
    final theme = Theme.of(context);
    final max = _maxValue;

    return List.generate(weeklyStats.length, (index) {
      final stat = weeklyStats[index];
      double val = 0;
      if (chartType == 'steps') {
        val = (stat['totalSteps'] as int? ?? 0).toDouble();
      } else if (chartType == 'calories') {
        val = (stat['totalCalories'] as num? ?? 0.0).toDouble();
      } else {
        val = (stat['totalMinutes'] as int? ?? 0).toDouble();
      }

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: val,
            gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                AppColors.primary,
                AppColors.secondary,
              ],
            ),
            width: 14,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: max,
              color: theme.brightness == Brightness.dark
                  ? AppColors.surfaceDark.withOpacity(0.5)
                  : Colors.grey.withOpacity(0.1),
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (weeklyStats.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text('No stats data available'),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _maxValue,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => isDark ? AppColors.surfaceDark : Colors.white,
              tooltipBorder: BorderSide(
                color: (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight).withOpacity(0.2),
              ),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final dateStr = weeklyStats[group.x]['date'] as String;
                final date = DateTime.parse(dateStr);
                final dayName = DateFormat.EEEE().format(date);
                
                String suffix = '';
                if (chartType == 'steps') {
                  suffix = ' steps';
                } else if (chartType == 'calories') {
                  suffix = ' kcal';
                } else {
                  suffix = ' min';
                }

                return BarTooltipItem(
                  '$dayName\n',
                  TextStyle(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: rod.toY.toStringAsFixed(0) + suffix,
                      style: TextStyle(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= weeklyStats.length) {
                    return const SizedBox.shrink();
                  }
                  final dateStr = weeklyStats[index]['date'] as String;
                  final date = DateTime.parse(dateStr);
                  final label = DateFormat.E().format(date);
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8,
                    child: Text(
                      label,
                      style: TextStyle(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  // Only display major values
                  if (value == 0) return const SizedBox.shrink();
                  String formattedVal = value.toStringAsFixed(0);
                  if (value >= 1000) {
                    formattedVal = '${(value / 1000).toStringAsFixed(1)}k';
                  }
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      formattedVal,
                      style: TextStyle(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        fontSize: 9,
                      ),
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
            horizontalInterval: _maxValue / 4 > 0 ? _maxValue / 4 : 1.0,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight).withOpacity(0.1),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(show: false),
          barGroups: _buildBarGroups(context),
        ),
      ),
    );
  }
}
