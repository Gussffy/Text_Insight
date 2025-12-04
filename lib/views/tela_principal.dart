import 'package:text_insight/views/tela_login.dart';
import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../models/analise_resultado.dart';
import 'tela_resultados.dart';

class TelaPrincipal extends StatefulWidget {
  final Usuario usuario;

  const TelaPrincipal({Key? key, required this.usuario}) : super(key: key);

  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  final TextEditingController _controladorTexto = TextEditingController();
  final FocusNode _noFoco = FocusNode();

  @override
  void initState() {
    super.initState();
    _noFoco.requestFocus();
  }

  @override
  void dispose() {
    _controladorTexto.dispose();
    _noFoco.dispose();
    super.dispose();
  }

  void _limparTexto() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar texto'),
        content: const Text('Tem certeza que deseja limpar todo o texto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _controladorTexto.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Texto limpo com sucesso!'),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Limpar'),
          ),
        ],
      ),
    );
  }

  AnaliseResultado _analisarTexto(String texto) {
    // Contagem básica de caracteres
    final contagemCaracteres = texto.length;
    final contagemCaracteresSemEspacos = texto
        .replaceAll(RegExp(r'\s+'), '')
        .length;

    // Divide o texto em palavras, removendo espaços extras
    final palavras = texto
        .trim()
        .split(RegExp(r'\s+'))
        .where((palavra) => palavra.isNotEmpty)
        .toList();
    final contagemPalavras = palavras.length;

    // Divide o texto em frases baseando-se em pontuação
    final frases = texto
        .split(RegExp(r'[.!?]+'))
        .where((frase) => frase.trim().isNotEmpty)
        .toList();
    final contagemFrases = frases.length;

    // Calcula tempo estimado de leitura (250 palavras por minuto)
    final tempoLeitura = (contagemPalavras / 250).ceil();

    // Calcula palavras mais frequentes
    final palavrasFrequentes = _calcularPalavrasFrequentes(palavras);

    return AnaliseResultado(
      contagemCaracteres: contagemCaracteres,
      contagemCaracteresSemEspacos: contagemCaracteresSemEspacos,
      contagemPalavras: contagemPalavras,
      contagemFrases: contagemFrases,
      tempoLeitura: tempoLeitura,
      palavrasFrequentes: palavrasFrequentes,
    );
  }

  List<MapEntry<String, int>> _calcularPalavrasFrequentes(List<String> palavras) {
    final palavrasLigacao = {
      'a', 'o', 'que', 'de', 'para', 'com', 'sem', 'mas', 'e', 'ou',
      'entre', 'em', 'por', 'da', 'do', 'na', 'no', 'as', 'os', 'um',
      'uma', 'uns', 'umas', 'ao', 'aos', 'à', 'às', 'pelo', 'pelos',
      'pela', 'pelas', 'num', 'nums', 'numa', 'numas', 'dum', 'duns',
      'duma', 'dumas',
    };

    final frequenciaPalavras = <String, int>{};

    for (final palavra in palavras) {
      final palavraLimpa = palavra.toLowerCase().replaceAll(
        RegExp(r'[^\w]'),
        '',
      );
      if (palavraLimpa.isNotEmpty && !palavrasLigacao.contains(palavraLimpa)) {
        frequenciaPalavras[palavraLimpa] =
            (frequenciaPalavras[palavraLimpa] ?? 0) + 1;
      }
    }

    final palavrasOrdenadas = frequenciaPalavras.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return palavrasOrdenadas.take(10).toList();
  }

  void _analisarENavegar() {
    final texto = _controladorTexto.text.trim();

    if (texto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, digite algum texto para analisar.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final resultado = _analisarTexto(texto);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaResultados(
          resultado: resultado,
          textoAnalisado: texto,
          usuario: widget.usuario,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Insight'),
        elevation: 2,
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _limparTexto,
            icon: const Icon(Icons.clear_all),
            tooltip: 'Limpar texto',
          ),
          IconButton(
            onPressed: () {
              // Logout
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (ctx) => const TelaLogin()),
              );
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Olá, ${widget.usuario.nome.split(' ').first}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            widget.usuario.email,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Digite seu texto:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _controladorTexto,
                      focusNode: _noFoco,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const InputDecoration(
                        hintText: 'Digite ou cole seu texto aqui...',
                        contentPadding: EdgeInsets.all(16),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
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
                      onPressed: _analisarENavegar,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.analytics, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'ANALISAR TEXTO',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    'Clique no botão acima para analisar seu texto',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        height: 50,
        color: Colors.blue[50],
        child: Center(
          child: Text(
            'Produzido por Gustavo Santos',
            style: TextStyle(
              color: Colors.blue[700],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}