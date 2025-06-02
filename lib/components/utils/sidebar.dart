//import 'package:aula_ia/screens/horario/horario_screen.dart';
//import 'package:aula_ia/screens/materia/materia_screen.dart';
//import 'package:aula_ia/screens/prediccion/prediccion_screen.dart';

import 'package:flutter/material.dart';
import 'package:aula_ia/screens/screens.dart';
import 'package:aula_ia/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<AuthService>(builder: (context, auth, child) {
        if (!auth.authentificated) {
          return ListView(
            children: [
              // Vista personalizada para el encabezado cuando no está autenticado
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/utils/sidebar_fondo2.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Alineado a la izquierda
                  children: [
                    // CircleAvatar a la izquierda
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        'https://cdn.pixabay.com/photo/2018/11/13/22/01/avatar-3814081_640.png',
                      ),
                    ),
                    const SizedBox(
                        height: 10), // Espaciado entre el avatar y los textos
                    const Text(
                      'Identificate',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    /*const Text(
                      'Usuario no autenticado',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const Text(
                      'Por favor, inicie sesión',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),*/
                  ],
                ),
              ),
              // Otros elementos del Drawer
              ListTile(
                leading: const Icon(Icons.login),
                title: const Text('Iniciar sesión'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              ),
              const Divider(
                thickness: 3,
                indent: 15,
                endIndent: 15,
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Preguntas frecuentes'),
                onTap: () {
                  // Acción para mostrar FAQ
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Política de privacidad'),
                onTap: () {
                  // Acción para mostrar política de privacidad
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Sobre nosostros'),
                onTap: () {
                  // Acción para mostrar política de privacidad
                },
              ),
              /*ListTile(
                leading: const Icon(Icons.play_arrow),
                title: const Text('Fomulario'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateAssistanceScreen()));
                },
              ),*/
            ],
          );
        } else {
          return ListView(
            children: [
              // Vista personalizada para el encabezado cuando está autenticado
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/utils/sidebar_fondo2.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Alineado a la izquierda
                  children: [
                    // CircleAvatar a la izquierda
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        'https://cdn.pixabay.com/photo/2017/02/23/13/05/avatar-2092113_1280.png',
                      ),
                    ),
                    const SizedBox(
                        height: 10), // Espaciado entre el avatar y los textos
                    // Los textos debajo del CircleAvatar
                    Text(
                      '${auth.user.first_name} ${auth.user.last_name}',
                      //'Diego',
                      //auth.user.username,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      auth.user.email,
                      //'diego@gmail.com',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
              /*ListTile(
                leading: const Icon(Icons.shop),
                title: const Text('Modulo Compras'),
                onTap: () {
                  print('Módulo Compras seleccionado');
                },
              ),*/
              ListTile(
                leading: const Icon(Icons.menu_book),
                title: const Text('Materias'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MateriaScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: const Text('Horario'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HorarioScreen(),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.check_circle),
                title: const Text('Registrar asistencia'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AsistenciaScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.grade),
                title: const Text('Historial asistencia'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistorialAsistenciaScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.record_voice_over),
                title: const Text('Participación'),
                onTap: () {
                  // Acción para mostrar una muestra de ficha médica
                },
              ),
              ListTile(
                leading: const Icon(Icons.grade),
                title: const Text('Notas'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotasPorPeriodoScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.analytics),
                title: const Text('Progreso acadenico'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProgresoAcademicoScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.analytics),
                title: const Text('Predicción de rendimiento'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrediccionScreen(),
                    ),
                  );
                },
              ),
              const Divider(
                thickness: 3,
                indent: 15,
                endIndent: 15,
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Mi Perfil'),
                onTap: () {
                  // Acción para editar o ver perfil
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Cerrar sesión'),
                onTap: () {
                  Provider.of<AuthService>(context, listen: false).logout();
                },
              ),
            ],
          );
        }
      }),
    );
  }
}
