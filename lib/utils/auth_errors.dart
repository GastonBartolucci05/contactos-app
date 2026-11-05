String mensajeDeError(String code) {
  switch (code) {
    case 'invalid-credential':
      return 'Email o contraseña incorrectos';
    case 'invalid-email':
      return 'El email no es válido';
    case 'email-already-in-use':
      return 'Ya existe una cuenta con ese email';
    case 'weak-password':
      return 'La contraseña es muy débil';
    case 'network-request-failed':
      return 'Sin conexión a internet';
    default:
      return 'Ocurrió un error, intentá de nuevo';
  }
}
