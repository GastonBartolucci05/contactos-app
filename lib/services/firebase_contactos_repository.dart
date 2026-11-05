import 'package:aprendo_flutter/models/contact_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseContactosRepository {
  CollectionReference<Map<String, dynamic>> get _coleccion {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .collection('contactos');
  }

  Stream<List<Contacto>> escuchar() {
    return _coleccion.orderBy('nombre').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Contacto.fromFirebase(doc.id, doc.data()))
          .toList();
    });
  }

  Future<List<Contacto>> cargar() async {
    final snapshot = await _coleccion.get();
    return snapshot.docs
        .map((doc) => Contacto.fromFirebase(doc.id, doc.data()))
        .toList();
  }

  Future<Contacto> agregar(Contacto contacto) async {
    final ref = await _coleccion.add(contacto.toMap());

    return Contacto(
      nombre: contacto.nombre,
      telefono: contacto.telefono,
      id: ref.id,
      email: contacto.email,
    );
  }

  Future<void> editar(Contacto contacto) async {
    await _coleccion.doc(contacto.id).update(contacto.toMap());
  }

  Future<void> eliminar(String id) async {
    await _coleccion.doc(id).delete();
  }

  Future<void> restaurar(Contacto contacto) async {
    await _coleccion.doc(contacto.id).set(contacto.toMap());
  }
}
