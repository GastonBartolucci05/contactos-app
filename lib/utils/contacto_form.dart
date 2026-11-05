import 'package:aprendo_flutter/models/contact_model.dart';
import 'package:aprendo_flutter/utils/validators.dart';
import 'package:flutter/material.dart';

class ContactoForm extends StatefulWidget {
  final Contacto? contacto;
  final Set<String> telefonosExistentes;
  const ContactoForm({
    super.key,
    this.contacto,
    this.telefonosExistentes = const {},
  });

  @override
  State<ContactoForm> createState() => _ContactoFormState();
}

class _ContactoFormState extends State<ContactoForm> {
  late final TextEditingController nameController;
  late final TextEditingController telefonoController;
  late final TextEditingController emailController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.contacto?.nombre ?? '');
    telefonoController = TextEditingController(
      text: widget.contacto?.telefono ?? '',
    );
    emailController = TextEditingController(text: widget.contacto?.email ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    telefonoController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => validarNombre(value),
              ),
              const SizedBox(height: 6),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: telefonoController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Telefono',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final error = validarTelefono(value);
                  if (error != null) return error;

                  if (widget.telefonosExistentes.contains(value!.trim())) {
                    return 'Ya existe un contacto con ese teléfono';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: emailController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => validarEmail(value),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () {
                  final nombre = nameController.text.trim();
                  final telefono = telefonoController.text.trim();
                  final email = emailController.text.trim();

                  if (!_formKey.currentState!.validate()) return;

                  final editado = Contacto(
                    id: widget.contacto?.id,
                    nombre: nombre,
                    telefono: telefono,
                    email: email.isEmpty ? null : email,
                  );
                  Navigator.pop(context, editado);
                },
                child: Text(widget.contacto == null ? 'Agregar' : 'Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
