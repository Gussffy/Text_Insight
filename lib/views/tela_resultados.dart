import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../models/analise_resultado.dart';

class TelaResultados extends StatelessWidget {
  final AnaliseResultado resultado;
  final String textoAnalisado;
  final Usuario usuario;

  const TelaResultados({
    Key? key,
    required this.resultado,
    required this.textoAnalisado,
    required this.usuario,
  }) : super(key: key);

  Widget _construirCardEstatistica(String titulo, String valor) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              titulo,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              valor,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirListaPalavrasFrequentes() {
    if (resultado.palavrasFrequentes.isEmpty) {
      return Text(
        'Não foram encontradas palavras frequentes (palavras de ligação foram ignoradas).',
        style: TextStyle(
          color: Colors.grey[600],
          fontStyle: FontStyle.italic,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      );
    }

    return Column(
      children: resultado.palavrasFrequentes.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Chip(
                label: Text(
                  '${entry.value}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.blue[700],
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados da Análise'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Voltar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumo do texto analisado
            Card(
              elevation: 4,
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.text_fields, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'Resumo do Texto',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[100]!),
                      ),
                      child: Text(
                        textoAnalisado.length > 200
                            ? '${textoAnalisado.substring(0, 200)}...'
                            : textoAnalisado,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Texto com ${textoAnalisado.length} caracteres',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Estatísticas
            Text(
              '📊 Estatísticas Detalhadas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),

            Column(
              children: [
                _construirCardEstatistica(
                  'Caracteres (com espaços)',
                  '${resultado.contagemCaracteres}',
                ),
                _construirCardEstatistica(
                  'Caracteres (sem espaços)',
                  '${resultado.contagemCaracteresSemEspacos}',
                ),
                _construirCardEstatistica(
                  'Palavras',
                  '${resultado.contagemPalavras}',
                ),
                _construirCardEstatistica(
                  'Frases',
                  '${resultado.contagemFrases}',
                ),
                _construirCardEstatistica(
                  'Tempo de leitura estimado',
                  '${resultado.tempoLeitura} minuto(s)',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Palavras frequentes
            Text(
              '🔤 Palavras Mais Frequentes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '(Palavras de ligação como "a", "o", "de" foram ignoradas)',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),

            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _construirListaPalavrasFrequentes(),
              ),
            ),

            const SizedBox(height: 24),

            // Botão para nova análise
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.refresh, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'NOVA ANÁLISE',
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

            const SizedBox(height: 20),
          ],
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        height: 50,
        color: Colors.blue[50],
        child: Center(
          child: Text(
            'Analisado para: ${usuario.nome}',
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