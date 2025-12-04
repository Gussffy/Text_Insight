import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:intl/intl.dart';
import '../viewmodels/cadastro_viewmodel.dart';

class TelaCadastro extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final maskCpf = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CadastroViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Cadastro de Usuário",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Form(
            key: _formKey,
            onChanged: () => viewModel.atualizarEstado(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Preencha seus dados",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                _input(
                  label: "Nome Completo",
                  controller: viewModel.nomeController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Nome obrigatório";
                    }
                    if (value.trim().split(' ').length < 2) {
                      return "Digite nome e sobrenome";
                    }
                    return null;
                  },
                ),

                _input(
                  label: "CPF",
                  controller: viewModel.cpfController,
                  keyboard: TextInputType.number,
                  inputFormatters: [maskCpf],
                  validator: (value) =>
                      value == null || value.isEmpty ? "CPF obrigatório" : null,
                ),

                const SizedBox(height: 10),
                const Text(
                  "Data de Nascimento",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () async {
                    final now = DateTime.now();
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: now.subtract(Duration(days: 365 * 18)),
                      firstDate: DateTime(1900),
                      lastDate: now,
                    );
                    if (picked != null) viewModel.setDataNascimento(picked);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          viewModel.dataNascimento == null
                              ? "Selecionar data"
                              : DateFormat('dd/MM/yyyy')
                                  .format(viewModel.dataNascimento!),
                          style: TextStyle(
                            color: viewModel.dataNascimento == null
                                ? Colors.grey
                                : Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                        Icon(Icons.calendar_today,
                            size: 18, color: Colors.black54),
                      ],
                    ),
                  ),
                ),
                if (viewModel.dataNascimento == null)
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      "Data obrigatória",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),

                _input(
                  label: "E-mail",
                  controller: viewModel.emailController,
                  keyboard: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return "E-mail inválido";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),
                _input(
                  label: "Senha",
                  controller: viewModel.senhaController,
                  obscure: !viewModel.senhaVisivel,
                  suffix: IconButton(
                    icon: Icon(viewModel.senhaVisivel
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: viewModel.toggleSenhaVisibilidade,
                  ),
                  onChanged: viewModel.validarSenha,
                ),

                const SizedBox(height: 10),
                _senhaItem("Letra Maiúscula (A-Z)", viewModel.temMaiuscula),
                _senhaItem("Letra Minúscula (a-z)", viewModel.temMinuscula),
                _senhaItem("Número (0-9)", viewModel.temNumero),
                _senhaItem(
                    "Caractere Especial (!@#...)", viewModel.temEspecial),

                _input(
                  label: "Confirmar Senha",
                  controller: viewModel.confirmaSenhaController,
                  obscure: true,
                  validator: (value) {
                    if (value != viewModel.senhaController.text) {
                      return "As senhas não coincidem";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                viewModel.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: viewModel.isFormValid
                              ? () async {
                                  bool sucesso = await viewModel.cadastrar();
                                  if (sucesso) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Cadastro realizado com sucesso!")));
                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(viewModel.msgErro ??
                                            "Erro ao cadastrar"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              : null,
                          child: const Text(
                            "Cadastrar",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _input({
    required String label,
    required TextEditingController controller,
    TextInputType keyboard = TextInputType.text,
    List<dynamic>? inputFormatters,
    String? Function(String?)? validator,
    bool obscure = false,
    Widget? suffix,
    void Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        obscureText: obscure,
        onChanged: onChanged,
        inputFormatters: inputFormatters?.cast(),
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black54),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          suffixIcon: suffix,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }

  Widget _senhaItem(String text, bool ok) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle : Icons.circle_outlined,
            size: 18,
            color: ok ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: ok ? Colors.green : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
