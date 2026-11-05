class Contacto {
  final String? id;
  final String nombre;
  final String telefono;
  final String? email;

  const Contacto({
    this.id,
    required this.nombre,
    required this.telefono,
    this.email,
  });

  Contacto copyWith({String? nombre, String? telefono, String? email}) {
    return Contacto(
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {'nombre': nombre, 'telefono': telefono, 'email': email};
  }

  factory Contacto.fromMap(Map<String, dynamic> map) {
    return Contacto(
      nombre: map['nombre'] as String,
      telefono: map['telefono'] as String,
      email: map['email'] as String?,
    );
  }

  factory Contacto.ftomApi(Map<String, dynamic> map) {
    final telefonoCrudo = map['phone'] as String;
    final telefono = telefonoCrudo
        .split(' x')
        .first
        .replaceAll(RegExp(r'\D'), '');
    return Contacto(
      nombre: map['name'] as String,
      telefono: telefono,
      email: map['email'] as String?,
    );
  }

  factory Contacto.fromFirebase(String id, Map<String, dynamic> map) {
    return Contacto(
      id: id,
      nombre: map['nombre'] as String,
      telefono: map['telefono'] as String,
      email: map['email'] as String?,
    );
  }
}
