import 'package:aprendo_flutter/models/contact_model.dart';
import 'package:flutter/material.dart';

class ContactoCard extends StatelessWidget {
  final Contacto contacto;
  final VoidCallback onTap;
  final VoidCallback onEliminar;
  final VoidCallback onEdit;
  final bool compacta;

  const ContactoCard({
    super.key,
    required this.contacto,
    required this.onEdit,
    required this.onEliminar,
    required this.onTap,
    this.compacta = false,
  });

  @override
  Widget build(BuildContext context) {
    final nombre = contacto.nombre;
    final inicial = nombre.isEmpty ? '?' : nombre[0].toUpperCase();
    if (compacta) {
      return Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _avatar(inicial),
                const SizedBox(height: 8),
                Text(
                  contacto.nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  contacto.telefono,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(onPressed: onEliminar, icon: Icon(Icons.delete)),
                    IconButton(onPressed: onEdit, icon: Icon(Icons.edit)),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Card(
      child: ListTile(
        leading: _avatar(inicial),
        title: Text(contacto.nombre),
        subtitle: Text('${contacto.telefono} - ${contacto.email ?? '-'}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: onEliminar, icon: Icon(Icons.delete)),
            IconButton(onPressed: onEdit, icon: Icon(Icons.edit)),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _avatar(String inicial) {
    return Stack(
      children: [
        CircleAvatar(child: Text(inicial)),
        if (contacto.email != null)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
