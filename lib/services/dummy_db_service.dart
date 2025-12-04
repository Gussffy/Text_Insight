import '../models/usuario.dart';

class DummyDBService {
  final List<Usuario> _usuarios = [];

  Future<Usuario?> getUsuarioByEmail(String email) async {
    await Future.delayed(Duration(milliseconds: 200));
    try {
      return _usuarios.firstWhere((u) => u.email == email);
    } catch (_) {
      return null;
    }
  }

  Future<void> insertUsuario(Usuario usuario) async {
    await Future.delayed(Duration(milliseconds: 200));
    _usuarios.add(usuario);
  }
}
