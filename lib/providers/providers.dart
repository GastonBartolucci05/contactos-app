import 'package:aprendo_flutter/models/contact_model.dart';
import 'package:aprendo_flutter/services/contactos_api.dart';
import 'package:aprendo_flutter/services/firebase_contactos_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final repositorioProvider = Provider<FirebaseContactosRepository>((ref) {
  return FirebaseContactosRepository();
});

final contactosProvider = StreamProvider<List<Contacto>>((ref) {
  final repo = ref.watch(repositorioProvider);
  return repo.escuchar();
});

class VistaNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void alternar() {
    state = !state;
  }
}

final esGrillaProvider = NotifierProvider<VistaNotifier, bool>(
  VistaNotifier.new,
);

class ImportarNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  Future<int> importar() async {
    state = true;
    try {
      final repo = ref.read(repositorioProvider);
      final actuales = ref.read(contactosProvider).value ?? [];

      final importados = await obtenerContactosApi();
      final telefonos = actuales.map((c) => c.telefono).toSet();
      final nuevos = importados
          .where((c) => !telefonos.contains(c.telefono))
          .toList();

      for (final c in nuevos) {
        await repo.agregar(c);
      }
      return nuevos.length;
    } finally {
      state = false;
    }
  }
}

final importandoProvider = NotifierProvider<ImportarNotifier, bool>(
  ImportarNotifier.new,
);

class ContactosAcciones {
  ContactosAcciones(this._repo);

  final FirebaseContactosRepository _repo;
  static const _espera = Duration(seconds: 10);

  Future<void> agregar(Contacto c) async {
    await _repo.agregar(c).timeout(_espera);
  }

  Future<void> eliminar(Contacto c) async {
    await _repo.eliminar(c.id!).timeout(_espera);
  }

  Future<void> editar(Contacto c) async {
    await _repo.editar(c).timeout(_espera);
  }

  Future<void> restaurar(Contacto c) async {
    await _repo.restaurar(c).timeout(_espera);
  }
}

final accionesProvider = Provider<ContactosAcciones>((ref) {
  return ContactosAcciones(ref.watch(repositorioProvider));
});
