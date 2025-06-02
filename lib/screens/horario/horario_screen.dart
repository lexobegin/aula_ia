// screens/schedule/horario_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aula_ia/models/models.dart';
import 'package:aula_ia/services/auth/auth_service.dart';
import 'package:aula_ia/widgets/widgets.dart';

class HorarioScreen extends StatefulWidget {
  const HorarioScreen({Key? key}) : super(key: key);

  @override
  State<HorarioScreen> createState() => _HorarioScreenState();
}

class _HorarioScreenState extends State<HorarioScreen> {
  List<Horario> horarios = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarHorarios();
  }

  void cargarHorarios() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      final horariosApi = await authService.getHorariosAlumno();
      setState(() {
        horarios = horariosApi;
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar horarios: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Horario'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : horarios.isEmpty
              ? const Center(child: Text('No hay horarios registrados'))
              : ListView.builder(
                  itemCount: horarios.length,
                  itemBuilder: (context, index) {
                    return HorarioCard(horario: horarios[index]);
                  },
                ),
    );
  }
}
