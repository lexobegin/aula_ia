import 'package:flutter/material.dart';

//import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:aula_ia/models/models.dart';
import 'package:aula_ia/services/auth/auth_service.dart';
import 'package:aula_ia/widgets/widgets.dart';

class MateriaScreen extends StatefulWidget {
  const MateriaScreen({Key? key}) : super(key: key);

  @override
  State<MateriaScreen> createState() => _MateriaScreenState();
}

class _MateriaScreenState extends State<MateriaScreen> {
  List<Materia> materias = [];
  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarMaterias();
  }

  void cargarMaterias() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      final materiasApi = await authService.getMateriasInscritas();
      setState(() {
        materias = materiasApi;
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar materias: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Materia> materiasFiltradas = materias.where((m) {
      return m.nombre.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Materias Disponibles'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar materia...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : materiasFiltradas.isEmpty
              ? const Center(child: Text('No se encontraron materias'))
              : ListView.builder(
                  itemCount: materiasFiltradas.length,
                  itemBuilder: (context, index) {
                    return MateriaCard(materia: materiasFiltradas[index]);
                  },
                ),
    );
  }
}
