import 'package:aprendo_flutter/models/contact_model.dart';
import 'package:flutter/material.dart';

Future<bool> confirmarEliminar(BuildContext context, Contacto contacto) async {
  final confirmar = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Eliminar'),
      content: Text('¿Seguro que desea eliminar ${contacto.nombre}?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(dialogContext, false);
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(dialogContext, true);
          },
          child: Text('Eliminar'),
        ),
      ],
    ),
  );
  return confirmar == true;
}
