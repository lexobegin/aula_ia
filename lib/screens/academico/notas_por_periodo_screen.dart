import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aula_ia/services/auth/auth_service.dart';
import 'package:aula_ia/models/models.dart';
import 'package:aula_ia/widgets/widgets.dart';

class NotasPorPeriodoScreen extends StatefulWidget {
  const NotasPorPeriodoScreen({Key? key}) : super(key: key);

  @override
  State<NotasPorPeriodoScreen> createState() => _NotasPorPeriodoScreenState();
}

class _NotasPorPeriodoScreenState extends State<NotasPorPeriodoScreen> {
  List<NotaPeriodo> _notas = [];
  List<String> _periodosDisponibles = [];
  String _selectedPeriod = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGrades();
  }

  Future<void> _loadGrades({String? periodo}) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      final response = await authService.getNotasPorPeriodo(periodo: periodo);
      setState(() {
        //_notas = response['notas'];
        //_periodosDisponibles = response['periodos_disponibles'];
        //_selectedPeriod = periodo ?? '';
        _notas = response['notas'].cast<NotaPeriodo>(); // Conversión explícita
        _periodosDisponibles = response['periodos_disponibles'].cast<String>();
        _selectedPeriod = periodo ?? '';
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar notas: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Notas por Período')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filtro por período (Chips)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: _periodosDisponibles.map((periodo) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilterChip(
                          label: Text(periodo),
                          selected: _selectedPeriod == periodo,
                          onSelected: (selected) {
                            _loadGrades(periodo: selected ? periodo : null);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Gráfico y lista
                Expanded(
                  child: _notas.isEmpty
                      ? const Center(child: Text('No hay notas registradas'))
                      : ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            GraficoNotas(
                              notas: _notas,
                              parentContext:
                                  context, // Pasar el contexto para SnackBar
                            ),
                            const SizedBox(height: 20),
                            ..._notas.map((nota) => _buildGradeCard(nota)),
                          ],
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildGradeCard(NotaPeriodo nota) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
