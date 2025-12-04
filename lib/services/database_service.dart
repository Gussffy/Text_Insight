import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/usuario.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  final String _boxName = 'usuariosBox';

  String _hashSenha(String senha) {
    var bytes = utf8.encode(senha);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<Box> get _box async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }
    return await Hive.openBox(_boxName);
  }

  Future<bool> cadastrarUsuario(Usuario usuario) async {
    final box = await _box;

    final existeUsuario = box.values.any((u) {
      final map = Map<String, dynamic>.from(u);
      return map['email'] == usuario.email;
    });

    if (existeUsuario) {
      throw Exception("E-mail já cadastrado.");
    }

    final usuarioSeguro = Usuario(
      // O ID será gerado pelo Hive (key)
      nome: usuario.nome,
      cpf: usuario.cpf,
      dataNascimento: usuario.dataNascimento,
      email: usuario.email,
      senha: _hashSenha(usuario.senha),
    );

    await box.add(usuarioSeguro.toMap());
    return true;
  }

  Future<Usuario?> login(String email, String senha) async {
    final box = await _box;
    final senhaHash = _hashSenha(senha);

    try {
      final usuarioMapDynamic = box.values.firstWhere(
        (element) {
          final userMap = Map<String, dynamic>.from(element);
          return userMap['email'] == email && userMap['senha'] == senhaHash;
        },
      );

      if (usuarioMapDynamic != null) {
        // Converte o Dynamic Map de volta para Objeto Usuario
        final userMap = Map<String, dynamic>.from(usuarioMapDynamic);
        return Usuario.fromMap(userMap);
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
