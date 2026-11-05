import 'dart:async';
import 'package:aprendo_flutter/models/contact_model.dart';
import 'package:aprendo_flutter/providers/providers.dart';
import 'package:aprendo_flutter/screens/detalle_screen.dart';
import 'package:aprendo_flutter/services/auth_service.dart';
import 'package:aprendo_flutter/utils/dialog.dart';
import 'package:aprendo_flutter/utils/contacto_form.dart';
import 'package:aprendo_flutter/widgets/contacto_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListScreen extends ConsumerStatefulWidget {
  const ListScreen({super.key});

  @override
  ConsumerState<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends ConsumerState<ListScreen> {
  List<Contacto> get _contactos => ref.read(contactosProvider).value ?? [];
  ContactosAcciones get _acciones => ref.read(accionesProvider);

  Future<void> _eliminar(Contacto contacto) async {
    try {
      await _acciones.eliminar(contacto);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${contacto.nombre} fue eliminado'),
          action: SnackBarAction(
            label: 'Deshacer',
            onPressed: () async {
              try {
                await _acciones.restaurar(contacto);
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('No se pudo realizar la acción')),
                );
              }
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo eliminar el contacto')),
      );
    }
  }

  Future<void> _editar(Contacto contacto) async {
    final telefonos = _contactos
        .where((c) => c.id != contacto.id)
        .map((c) => c.telefono)
        .toSet();

    final editado = await showModalBottomSheet<Contacto>(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          ContactoForm(contacto: contacto, telefonosExistentes: telefonos),
    );
    if (!mounted) return;

    if (editado != null) {
      try {
        await _acciones.editar(editado);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('No se pudo guardar el cambio')));
      }
    }
  }

  Future<void> _confirmarYEliminar(Contacto contacto) async {
    final eliminar = await confirmarEliminar(context, contacto);
    if (!mounted) return;
    if (eliminar) {
      _eliminar(contacto);
    }
  }

  Future<void> _abrirDetalle(Contacto contacto) async {
    final eliminar = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => DetalleScreen(contacto: contacto)),
    );

    if (!mounted) return;

    if (eliminar == true) {
      _eliminar(contacto);
    }
  }

  Future<void> _importar() async {
    try {
      final cantidad = await ref.read(importandoProvider.notifier).importar();
      if (!mounted) return;
      final mensaje = cantidad == 0
          ? 'No hay contactos nuevos para importar'
          : 'Se importaron $cantidad contactos';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mensaje)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No se pudo importar')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final esGrilla = ref.watch(esGrillaProvider);
    final ancho = MediaQuery.of(context).size.width;
    final esAncho = ancho > 600;
    final mostrarGrilla = esGrilla || esAncho;
    final contactosAsync = ref.watch(contactosProvider);
    final importando = ref.watch(importandoProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Contactos'),
        actions: [
          IconButton(
            onPressed: () => AuthService().cerrarSesion(),
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
          ),
          IconButton(
            onPressed: _importar,
            icon: const Icon(Icons.cloud_download),
            tooltip: 'Importar',
          ),
          if (!esAncho)
            IconButton(
              onPressed: () {
                setState(() {
                  ref.read(esGrillaProvider.notifier).alternar();
                });
              },
              icon: Icon(esGrilla ? Icons.view_list : Icons.grid_view),
            ),
        ],
      ),
      body: importando
          ? const Center(child: CircularProgressIndicator())
          : contactosAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Error al cargar contactos'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(contactosProvider),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
              data: (contactos) => _contenido(contactos, mostrarGrilla),
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final nuevo = await showModalBottomSheet<Contacto>(
            context: context,
            isScrollControlled: true,
            builder: (_) => ContactoForm(
              telefonosExistentes: _contactos.map((c) => c.telefono).toSet(),
            ),
          );

          try {
            if (!mounted) return;

            if (nuevo != null) {
              await _acciones.agregar(nuevo);
            }
          } catch (e) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No se pudo agregar el contacto')),
            );
          }
        },

        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _tarjeta(Contacto contacto, {bool compacta = false}) {
    return ContactoCard(
      contacto: contacto,
      compacta: compacta,
      onEdit: () => _editar(contacto),
      onEliminar: () => _confirmarYEliminar(contacto),
      onTap: () => _abrirDetalle(contacto),
    );
  }

  Widget _contenido(List<Contacto> contactos, bool mostrarGrilla) {
    if (_contactos.isEmpty) {
      return Center(
        child: Text('No hay contactos registrados, tocá "+" para agrgar '),
      );
    }

    return mostrarGrilla
        ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _contactos.length,
            itemBuilder: (context, index) {
              return _tarjeta(contactos[index], compacta: true);
            },
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              return _tarjeta(contactos[index]);
            },
            itemCount: _contactos.length,
          );
  }
}
