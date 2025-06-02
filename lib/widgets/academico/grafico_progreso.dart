import 'package:flutter/material.dart';
//import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fl_chart/fl_chart.dart';

class GraficoProgreso extends StatelessWidget {
  final Map<String, double> promediosGenerales;

  const GraficoProgreso({Key? key, required this.promediosGenerales})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Convertir datos para el gráfico
    final List<BarChartGroupData> barGroups =
        promediosGenerales.entries.map((entry) {
      final color = entry.value >= 70
          ? Colors.green
          : entry.value >= 50
              ? Colors.orange
              : Colors.red;

      return BarChartGroupData(
        x: promediosGenerales.keys.toList().indexOf(entry.key),
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: color,
            width: 20,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    promediosGenerales.keys.elementAt(value.toInt()),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                getTitlesWidget: (value, meta) {
                  return Text(value.toInt().toString());
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: true),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${rod.toY.toStringAsFixed(1)}',
                  TextStyle(color: rod.color),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// Clase auxiliar para los datos del gráfico
class _ChartData {
  final String periodo;
  final double promedio;
  final Color color;

  _ChartData(this.periodo, this.promedio, this.color);
}
