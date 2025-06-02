import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aula_ia/services/auth/auth_service.dart';
import 'package:aula_ia/models/models.dart';
import 'package:aula_ia/widgets/widgets.dart';
//import 'package:charts_flutter/flutter.dart' as charts;

class ProgresoAcademicoScreen extends StatefulWidget {
  const ProgresoAcademicoScreen({Key? key}) : super(key: key);

  @override
  State<ProgresoAcademicoScreen> createState() =>
      _ProgresoAcademicoScreenState();
}

class _ProgresoAcademicoScreenState extends State<ProgresoAcademicoScreen> {
  ProgresoAcademico? _progreso;
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadAcademicProgress();
  }

  Future<void> _loadAcademicProgress() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      final progreso = await authService.getProgresoAcademico();
      setState(() {
        _progreso = progreso;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar el progreso: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Progreso Académico')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : _progreso == null
                  ? const Center(child: Text('No hay datos disponibles'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Gráfico de promedios generales
                          GraficoProgreso(
                              promediosGenerales:
                                  _progreso!.promediosGenerales),
                          const SizedBox(height: 24),
                          // Lista de notas por materia
                          const Text(
                            'Notas por Materia',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          ..._progreso!.notasPorMateria
                              .map((nota) => _buildMateriaCard(nota)),
                        ],
                      ),
                    ),
    );
  }

  /*Widget _buildPromediosGeneralesChart(Map<String, double> promedios) {
    final data = promedios.entries
        .map((entry) => _ChartData(
              entry.key,
              entry.value,
              entry.value >= 70
                  ? Colors.green
                  : entry.value >= 50
                      ? Colors.orange
                      : Colors.red,
            ))
        .toList();

    return SizedBox(
      height: 200,
      child: charts.BarChart(
        [
          charts.Series<_ChartData, String>(
            id: 'Promedios',
            data: data,
            domainFn: (_ChartData d, _) => d.periodo,
            measureFn: (_ChartData d, _) => d.promedio,
            colorFn: (_ChartData d, _) =>
                charts.ColorUtil.fromDartColor(d.color),
            labelAccessorFn: (_ChartData d, _) =>
                '${d.promedio.toStringAsFixed(1)}',
          )
        ],
        animate: true,
        vertical: false,
        barRendererDecorator: charts.BarLabelDecorator<String>(),
        domainAxis: const charts.OrdinalAxisSpec(
            renderSpec: charts.SmallTickRendererSpec(
          labelRotation: 0,
          labelStyle: charts.TextStyleSpec(fontSize: 10),
        )),
      ),
    );
  }*/

  Widget _buildMateriaCard(NotaMateria nota) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nota.materia,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Período: ${nota.periodo}'),
                Text('Promedio: ${nota.promedio.toStringAsFixed(1)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Clase auxiliar para gráficos
class _ChartData {
  final String periodo;
  final double promedio;
  final Color color;

  _ChartData(this.periodo, this.promedio, this.color);
}
