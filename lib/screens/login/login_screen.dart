import 'package:flutter/material.dart';
import 'package:aula_ia/providers/providers.dart';
import 'package:aula_ia/services/auth/auth_service.dart';
import 'package:aula_ia/screens/screens.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicia sesión'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 20), // Espacio a los lados
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100), // Espaciado superior
              // Formulario de inicio de sesión centrado
              ChangeNotifierProvider(
                create: (_) => loginformprovider(),
                child: _LoginForm(),
              ),
              const SizedBox(
                  height:
                      30), // Espaciado inferior entre el formulario y el texto
              // Texto de bienvenida
              const Text(
                'Bienvenido a nuestra App movil',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50), // Espaciado inferior
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<loginformprovider>(context);

    return Form(
      key: loginForm.formkey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.text,
            onChanged: (value) => loginForm.username = value,
            decoration: const InputDecoration(
              hintText: 'Username',
            ),
          ),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            onChanged: (value) => loginForm.password = value,
            decoration: const InputDecoration(
              hintText: 'Contraseña',
            ),
            validator: (value) {
              if (value != null && value.length >= 8) return null;
              return 'La contraseña es demasiado corta';
            },
          ),
          const SizedBox(height: 30),
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.blue,
            onPressed: loginForm.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    if (!loginForm.isValidForm()) return;
                    loginForm.isLoading = true;
                    await Future.delayed(const Duration(seconds: 2));

                    final authService =
                        Provider.of<AuthService>(context, listen: false);

                    String respuesta = await authService.login(
                        loginForm.username, loginForm.password);

                    if (respuesta == 'correcto') {
                      loginForm.isLoading = false;
                      //Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    }
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text(
                loginForm.isLoading ? 'Espere' : 'Ingresar',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DialogoAlerta extends StatelessWidget {
  final String mensaje;

  const _DialogoAlerta({required this.mensaje});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error'),
      content: Text(mensaje),
    );
  }
}
