import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:aula_ia/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:aula_ia/services/services.dart';

import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  bool _isLoggerdIn = false;
  User? _user;
  String? _token;
  String? _refresh;

  bool get authentificated => _isLoggerdIn;
  User get user => _user!;
  Servidor servidor = Servidor();

  final _storage = const FlutterSecureStorage();

  /*Future<String> loginO(String email, String password) async {
    try {
      final response =
          await http.post(Uri.parse('${servidor.baseUrl}/auth/jwt/create/'),
              body: ({
                'email': email,
                'password': password,
              }));

      //print(response.statusCode);
      //print(response.body);
      if (response.statusCode == 200) {
        //String token = response.body.toString();
        // Parsear el cuerpo de la respuesta (JSON)
        Map<String, dynamic> responseJson = jsonDecode(response.body);

        // Extraer los tokens
        String accessToken = responseJson['access'];
        //String refreshToken = responseJson['refresh'];

        // Imprimir los tokens para depuración
        //print('Access Token: $accessToken');
        //print('Refresh Token: $refreshToken');
        //tryToken(token);
        tryToken(accessToken);
        return 'correcto';
      } else {
        return 'incorrecto';
      }
    } catch (e) {
      return 'error';
    }
  }*/

  Future<String> login(String username, String password) async {
    try {
      final response =
          await http.post(Uri.parse('${servidor.baseUrl}/auth/token/'),
              headers: {
                'Content-Type': 'application/json',
              },
              body: json.encode({
                'username': username,
                'password': password,
              }));
      print('OKKKKK');
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = jsonDecode(response.body);

        // Extraer los tokens
        String refreshToken = responseJson['refresh'];
        // Extraer los tokens
        String accessToken = responseJson['access'];

        tryToken(refreshToken, accessToken);
        return 'correcto';
      } else {
        return 'incorrecto';
      }
    } catch (e) {
      return 'error';
    }
  }

  /*
  Future<String> register(String username, String firstname, String lastname,
      String email, String password) async {
    try {
      final response = await http.post(
          Uri.parse('${servidor.baseUrl}/auth/registro-cliente/'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'username': username,
            'first_name': firstname,
            'last_name': lastname,
            'email': email,
            'password': password,
          }));
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 201) {
        //String token = response.body.toString();
        //tryToken(token);

        return login(username, password);
      } else {
        return 'incorrecto';
      }
    } catch (e) {
      return 'error';
    }
  }*/

  void tryToken(String? refresh, String? token) async {
    if (token == null) {
      return;
    } else {
      try {
        final response = await http.get(
            Uri.parse('${servidor.baseUrl}/auth/me/'),
            headers: {'Authorization': 'Bearer $token'});

        print('response body: ${response.body}');
        _isLoggerdIn = true;
        _user = User.fromJson(jsonDecode(response.body));
        _token = token;
        _refresh = refresh;

        if (refresh != null) {
          storeToken(refresh, token);
        }
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
  }

  void storeToken(String refresh, String token) async {
    _storage.write(key: 'token', value: token);
    _storage.write(key: 'refresh', value: refresh);
  }

  void logout() async {
    try {
      /*final response = await http.post(
        Uri.parse('${servidor.baseUrl}/auth/token/refresh/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token', // opcional en refresh
        },
        body: jsonEncode({
          'refresh': _refresh,
        }),
      );

      if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['access']; // nuevo token de acceso
      notifyListeners();
    } else {
      // El refresh falló, hacemos logout real
      cleanUp();
      notifyListeners();
    }*/
      cleanUp();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void cleanUp() async {
    _user = null;
    _isLoggerdIn = false;
    _user = null;
    await _storage.delete(key: 'refresh');
    await _storage.delete(key: 'token');
  }

//Materia
  Future<List<Materia>> getMateriasInscritas() async {
    final response = await http.get(
      Uri.parse('${servidor.baseUrl}/inscripciones/?gestion_estado=EN%20CURSO'),
      headers: {'Authorization': 'Bearer $_token'},
    );
    final json = jsonDecode(response.body);
    final List<dynamic> inscripciones = json['results'];

    // Extraer todas las materias de cada inscripción
    final List<Materia> materias = [];
    for (final inscripcion in inscripciones) {
      final List<dynamic> materiasJson = inscripcion['materias'];
      materias.addAll(materiasJson.map((json) => Materia.fromJson(json)));
    }

    return materias;
  }

  // Horario
  Future<List<Horario>> getHorariosAlumno() async {
    final response = await http.get(
      Uri.parse('${servidor.baseUrl}/horarios/'),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => Horario.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar horarios');
    }
  }

  //Usuario actual //me
  Future<User> obtenerUsuarioActual() async {
    final response = await http.get(
      Uri.parse('${servidor.baseUrl}/auth/me/'),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Error al obtener usuario actual');
    }
  }

  // generarPrediccion
  Future<Prediccion> generarPrediccion() async {
    final usuario = await obtenerUsuarioActual();

    final response = await http.post(
      Uri.parse('${servidor.baseUrl}/predicciones/generar_prediccion/'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'alumno_id': usuario.id}),
    );

    if (response.statusCode == 200) {
      return Prediccion.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al generar predicción');
    }
  }

  //Asistencia
  // services/auth_service.dart
  Future<void> registrarAsistenciaAlumno({String? justificacion}) async {
    final response = await http.post(
      Uri.parse('${servidor.baseUrl}/asistencias/registrar_asistencia_alumno/'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'justificacion': justificacion,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception(jsonDecode(response.body)['error'] ??
          'Error al registrar asistencia');
    }
  }

  // Historial de asistencia
  Future<List<Asistencia>> getHistorialAsistencia() async {
    final response = await http.get(
      Uri.parse('${servidor.baseUrl}/asistencias/historial_alumno/'),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => Asistencia.fromJson(json)).toList();
    } else {
      throw Exception(
          jsonDecode(response.body)['error'] ?? 'Error al cargar historial');
    }
  }

  // Progreso Academico
  Future<ProgresoAcademico> getProgresoAcademico() async {
    final response = await http.get(
      Uri.parse('${servidor.baseUrl}/notas/progreso_academico/'),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      return ProgresoAcademico.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          jsonDecode(response.body)['error'] ?? 'Error al cargar progreso');
    }
  }

  // services/auth_service.dart
  Future<Map<String, dynamic>> getNotasPorPeriodo({String? periodo}) async {
    final url = periodo != null
        ? '${servidor.baseUrl}/notas/notas_por_periodo/?periodo=$periodo'
        : '${servidor.baseUrl}/notas/notas_por_periodo/';

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $_token'},
    );

    //if (response.statusCode == 200) {
    //return jsonDecode(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Convertir la lista de notas a List<NotaPeriodo>
      final notas = (data['notas'] as List)
          .map((item) => NotaPeriodo.fromJson(item))
          .toList();
      return {
        'notas': notas,
        'periodos_disponibles': List<String>.from(data['periodos_disponibles']),
      };
    } else {
      throw Exception(
          jsonDecode(response.body)['error'] ?? 'Error al cargar notas');
    }
  }

//Productos
  /*Future<List<Producto>> fetchProductos() async {
    final response =
        await http.get(Uri.parse('${servidor.baseUrl}/productos-list/'));
    print('PRODUCTO statusCode: ${response.statusCode}');
    print('PRODUCTO body: ${response.body}');
    if (response.statusCode == 200) {
      //final List<dynamic> data = json.decode(response.body);
      //return data.map((e) => Producto.fromJson(e)).toList();
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((e) => Producto.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }*/

  // Retorna productos + URL de next
  /*Future<Map<String, dynamic>> fetchProductosPaginados({String? url}) async {
    final response = await http.get(
      Uri.parse(url ?? '${servidor.baseUrl}/productos-list/'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      final productos = results.map((e) => Producto.fromJson(e)).toList();

      return {
        'productos': productos,
        'next': data['next'],
      };
    } else {
      throw Exception('Error al cargar productos');
    }
  }*/

  /*Future<bool> agregarAlCarrito(int productoId, int cantidad) async {
    final response = await http.post(
      Uri.parse('${servidor.baseUrl}/cli-carrito/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode({
        'producto_id': productoId,
        'cantidad': cantidad,
      }),
    );

    return response.statusCode == 201;
  }*/

  /*Future<List<CarritoItem>> fetchCarrito() async {
    final response = await http.get(
      Uri.parse('${servidor.baseUrl}/cli-carrito/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    print('CARRITO body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => CarritoItem.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar el carrito');
    }
  }*/

  /*Future<bool> eliminarCarritoItem(int itemId) async {
    final response = await http.delete(
      Uri.parse('${servidor.baseUrl}/cli-carrito/$itemId/'),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );
    return response.statusCode == 204;
  }*/

  /*Future<bool> actualizarCantidad(int itemId, int nuevaCantidad) async {
    final response = await http.patch(
      Uri.parse('${servidor.baseUrl}/cli-carrito/$itemId/cantidad/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode({'cantidad': nuevaCantidad}),
    );
    return response.statusCode == 200;
  }*/
}
