import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class VolumeChart extends StatelessWidget {
  const VolumeChart({super.key});

  @override
  Widget build(BuildContext context) {
    final muscles = ["Chest", "Back", "Legs", "Arms", "Shoulders", "Abs"];
    final volumes = [12000, 14500, 11000, 8000, 9500, 6000]; // sample data

    return AspectRatio(
      aspectRatio: 1.6,
      child: BarChart(
        BarChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      muscles[index],
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
                reservedSize: 28,
                interval: 1,
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          barGroups: List.generate(
            muscles.length,
            (i) => BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: volumes[i].toDouble() / 1000,
                  width: 18,
                  borderRadius: BorderRadius.circular(6),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
