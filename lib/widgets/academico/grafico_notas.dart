import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:aula_ia/models/models.dart';

class GraficoNotas extends StatelessWidget {
  final List<NotaPeriodo> notas;
  final BuildContext parentContext; // Para mostrar SnackBar

  const GraficoNotas(
      {Key? key, required this.notas, required this.parentContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250, // Más alto para evitar solapamiento
      child: BarChart(
        BarChartData(
          barGroups: notas.asMap().entries.map((entry) {
            final nota = entry.value;
            final color = nota.promedio >= 70
                ? Colors.green
                : nota.promedio >= 50
                    ? Colors.orange
                    : Colors.red;

            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: nota.promedio,
                  color: color,
                  width: 18, // Ancho aumentado
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return const SizedBox(); // Ocultamos títulos inferiores
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 10,
                getTitlesWidget: (value, meta) {
                  return Text(value.toInt().toString());
                },
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor:
                  const Color.fromARGB(0, 209, 13, 13), // Fondo transparente
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '', // Texto vacío (ocultamos el tooltip predeterminado)
                  const TextStyle(),
                );
              },
            ),
            touchCallback: (event, response) {
              if (response?.spot != null) {
                final index = response!.spot!.touchedBarGroupIndex;
                final materia = notas[index].materia;
                final promedio = notas[index].promedio;

                ScaffoldMessenger.of(parentContext).showSnackBar(
                  SnackBar(
                    content: Center(
                      child: Text(
                        '$materia: ${promedio.toStringAsFixed(1)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    duration: const Duration(seconds: 3),
                    backgroundColor: Colors.black54,
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.only(bottom: 100),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
