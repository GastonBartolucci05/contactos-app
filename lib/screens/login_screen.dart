import 'package:aprendo_flutter/services/auth_service.dart';
import 'package:aprendo_flutter/utils/auth_errors.dart';
import 'package:aprendo_flutter/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _fromKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmarController = TextEditingController();
  final _auth = AuthService();
  bool cargando = false;
  bool ocultarPassowrd = true;
  bool esRegistro = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmarController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!_fromKey.currentState!.validate()) return;

    setState(() {
      cargando = true;
    });

    try {
      if (esRegistro) {
        await _auth.registrar(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
      } else {
        await _auth.iniciarSesion(
          emailController.text.trim(),
          passwordController.text,
        );
      }

      if (!mounted) return;
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mensajeDeError(e.code))));
    } finally {
      if (!mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(esRegistro ? 'Crear cuenta' : 'Iniciar Sesión'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _fromKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: validarEmailLogin,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: passwordController,
                    obscureText: ocultarPassowrd,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            ocultarPassowrd = !ocultarPassowrd;
                          });
                        },
                        icon: Icon(
                          ocultarPassowrd
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: validarPassword,
                  ),
                  if (esRegistro) ...[
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: confirmarController,
                      obscureText: ocultarPassowrd,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Repetir Contraseña',
                        labelStyle: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      validator: (value) {
                        if (value != passwordController.text) {
                          return 'Las contraseñas deben coincidir';
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: cargando ? null : _entrar,
                    child: cargando
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(),
                          )
                        : Text(esRegistro ? 'Crear Cuenta' : 'Entrar'),
                  ),
                  TextButton(
                    onPressed: cargando
                        ? null
                        : () {
                            setState(() {
                              esRegistro = !esRegistro;
                            });
                            final email = emailController.text;
                            _fromKey.currentState!.reset();
                            emailController.text = email;
                            passwordController.clear();
                            confirmarController.clear();
                          },

                    child: Text(
                      esRegistro
                          ? '¿Ya tenés cuenta? Iniciá sesión'
                          : '¿No tenés cuenta? Registrate',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.blue,
    );
  }
}
