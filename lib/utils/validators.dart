String? validarNombre(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'El nombre es obligatorio';
  }
  return null;
}

String? validarTelefono(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'El número de telefono es obligatorio';
  }
  if (int.tryParse(value.trim()) == null) {
    return 'Solo números';
  }
  return null;
}

String? validarEmail(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  if (!value.contains('@')) {
    return 'El email es inválido';
  }
  return null;
}

String? validarPassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'La contraseña es obligatoria';
  }
  if (value.length < 6) {
    return 'Mínimo 6 caracteres';
  }
  return null;
}

String? validarEmailLogin(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'El email es obligatorio';
  }
  if (!value.contains('@')) {
    return 'El email es inválido';
  }
  return null;
}
