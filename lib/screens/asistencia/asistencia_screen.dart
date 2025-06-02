import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aula_ia/services/auth/auth_service.dart';
import 'package:intl/intl.dart';

class AsistenciaScreen extends StatefulWidget {
  const AsistenciaScreen({Key? key}) : super(key: key);

  @override
  State<AsistenciaScreen> createState() => _AsistenciaScreenState();
}

class _AsistenciaScreenState extends State<AsistenciaScreen> {
  bool _isLoading = false;
  bool _attendanceMarked = false;
  String _justification = '';
  DateTime _today = DateTime.now();

  Future<void> _markAttendance() async {
    setState(() => _isLoading = true);
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService.registrarAsistenciaAlumno(
        justificacion: _justification,
      );
      setState(() => _attendanceMarked = true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Asistencia')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Hoy: ${DateFormat('dd/MM/yyyy').format(_today)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (_attendanceMarked)
              const Column(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 50),
                  SizedBox(height: 10),
                  Text(
                    '¡Asistencia registrada!',
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                ],
              )
            else
              Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Justificación (opcional)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _justification = value,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _markAttendance,
                    icon: const Icon(Icons.how_to_reg),
                    label: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Confirmar Asistencia'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
