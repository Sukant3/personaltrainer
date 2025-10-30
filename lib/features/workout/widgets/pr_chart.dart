import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PRChart extends StatelessWidget {
  const PRChart({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      FlSpot(1, 100),
      FlSpot(2, 105),
      FlSpot(3, 110),
      FlSpot(4, 115),
      FlSpot(5, 125),
    ]; // example PR history

    return AspectRatio(
      aspectRatio: 1.6,
      child: LineChart(
        LineChartData(
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, _) => Text("W${val.toInt()}"),
                reservedSize: 22,
                interval: 1,
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: data,
              isCurved: true,
              color: Theme.of(context).colorScheme.secondary,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
