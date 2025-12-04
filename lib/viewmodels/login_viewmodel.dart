import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/database_service.dart';

class LoginViewModel extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();

  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  Future<Usuario?> login() async {
    _isLoading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final usuario = await _dbService.login(
        emailController.text,
        senhaController.text,
      );

      if (usuario == null) {
        _mensagemErro = "E-mail ou senha incorretos.";
      }

      _isLoading = false;
      notifyListeners();
      return usuario;
    } catch (e) {
      _mensagemErro = "Erro ao tentar fazer login.";
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
}