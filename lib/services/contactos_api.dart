import 'dart:convert';

import 'package:aprendo_flutter/models/contact_model.dart';
import 'package:http/http.dart' as http;

Future<List<Contacto>> obtenerContactosApi() async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/users');
  final respuesta = await http.get(url);

  if (respuesta.statusCode != 200) {
    throw Exception('Error del servidor: ${respuesta.statusCode}');
  }

  final lista = jsonDecode(respuesta.body) as List;
  return lista.map((c) => Contacto.ftomApi(c as Map<String, dynamic>)).toList();
}
