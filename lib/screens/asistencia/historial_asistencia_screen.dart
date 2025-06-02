import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aula_ia/services/auth/auth_service.dart';
import 'package:aula_ia/models/models.dart';
import 'package:aula_ia/widgets/widgets.dart';
//import 'package:intl/intl.dart';

class HistorialAsistenciaScreen extends StatefulWidget {
  const HistorialAsistenciaScreen({Key? key}) : super(key: key);

  @override
  State<HistorialAsistenciaScreen> createState() =>
      _HistorialAsistenciaScreenState();
}

class _HistorialAsistenciaScreenState extends State<HistorialAsistenciaScreen> {
  List<Asistencia> _asistencias = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadAttendanceHistory();
  }

  Future<void> _loadAttendanceHistory() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      final historial = await authService.getHistorialAsistencia();
      setState(() {
        _asistencias = historial;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar el historial: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Historial de Asistencia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAttendanceHistory,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : _asistencias.isEmpty
                  ? const Center(child: Text('No hay registros de asistencia'))
                  : ListView.builder(
                      itemCount: _asistencias.length,
                      itemBuilder: (context, index) {
                        return HistorialAsistenciaCard(
                            asistencia: _asistencias[index]);
                      },
                    ),
    );
  }
}
