import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/database_service.dart';

class CadastroViewModel extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();


  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmaSenhaController = TextEditingController();


  DateTime? _dataNascimento;
  DateTime? get dataNascimento => _dataNascimento;


  bool _senhaVisivel = false;
  bool get senhaVisivel => _senhaVisivel;

  bool temMaiuscula = false;
  bool temMinuscula = false;
  bool temNumero = false;
  bool temEspecial = false;


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _msgErro;
  String? get msgErro => _msgErro;


  bool get isFormValid =>
      nomeController.text.trim().split(' ').length >= 2 && // Nome + Sobrenome
      cpfController.text.isNotEmpty &&
      _dataNascimento != null &&
      emailController.text.contains('@') &&

      temMaiuscula &&
      temMinuscula &&
      temNumero &&
      temEspecial &&

      senhaController.text == confirmaSenhaController.text;


  void toggleSenhaVisibilidade() {
    _senhaVisivel = !_senhaVisivel;
    notifyListeners();
  }

  void setDataNascimento(DateTime data) {
    _dataNascimento = data;
    notifyListeners();
  }

  void validarSenha(String value) {
    temMaiuscula = value.contains(RegExp(r'[A-Z]'));
    temMinuscula = value.contains(RegExp(r'[a-z]'));
    temNumero = value.contains(RegExp(r'[0-9]'));
    temEspecial = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    notifyListeners(); // Atualiza a UI (Checkboxes/Ícones)
  }


  void atualizarEstado() {
    notifyListeners();
  }


  Future<bool> cadastrar() async {

    if (!isFormValid) return false;

    _isLoading = true;
    _msgErro = null;
    notifyListeners();

    try {
      final novoUsuario = Usuario(
        nome: nomeController.text.trim(),
        cpf: cpfController.text.trim(),
        dataNascimento: _dataNascimento!.toIso8601String(),
        email: emailController.text.trim(),
        senha: senhaController.text,
      );

      await _dbService.cadastrarUsuario(novoUsuario);

      _isLoading = false;
      notifyListeners();
      return true; // Sucesso
    } catch (e) {

      _msgErro = e.toString().replaceAll("Exception: ", "");

      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
