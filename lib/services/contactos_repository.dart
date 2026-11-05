import 'dart:convert';

import 'package:aprendo_flutter/models/contact_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactosRepository {
  static const _clave = 'contactos';

  Future<List<Contacto>> cargar() async {
    final prefs = await SharedPreferences.getInstance();
    final texto = prefs.getString(_clave);

    if (texto == null) return [];

    final lista = jsonDecode(texto) as List;
    return lista
        .map((c) => Contacto.fromMap(c as Map<String, dynamic>))
        .toList();
  }

  Future<void> guardar(List<Contacto> contacos) async {
    final prefs = await SharedPreferences.getInstance();
    final lista = contacos.map((m) => m.toMap()).toList();
    await prefs.setString(_clave, jsonEncode(lista));
  }
}
