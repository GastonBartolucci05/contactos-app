import 'package:aprendo_flutter/models/contact_model.dart';
import 'package:aprendo_flutter/utils/dialog.dart';
import 'package:flutter/material.dart';

class DetalleScreen extends StatelessWidget {
  final Contacto contacto;
  const DetalleScreen({super.key, required this.contacto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(contacto.nombre)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Detalle de ${contacto.nombre}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Num. de telefono: ${contacto.telefono}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          if (contacto.email != null)
            Text(
              'Email: ${contacto.email!}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Volver'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () async {
                final confirmar = await confirmarEliminar(context, contacto);
                if (!context.mounted) return;
                if (confirmar) {
                  Navigator.pop(context, true);
                }
              },
              child: const Text('Eliminar'),
            ),
          ),
        ],
      ),
    );
  }
}
