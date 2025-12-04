class AnaliseResultado {
  final int contagemCaracteres;
  final int contagemCaracteresSemEspacos;
  final int contagemPalavras;
  final int contagemFrases;
  final int tempoLeitura;
  final List<MapEntry<String, int>> palavrasFrequentes;

  AnaliseResultado({
    required this.contagemCaracteres,
    required this.contagemCaracteresSemEspacos,
    required this.contagemPalavras,
    required this.contagemFrases,
    required this.tempoLeitura,
    required this.palavrasFrequentes,
  });

  Map<String, dynamic> toMap() {
    return {
      'contagemCaracteres': contagemCaracteres,
      'contagemCaracteresSemEspacos': contagemCaracteresSemEspacos,
      'contagemPalavras': contagemPalavras,
      'contagemFrases': contagemFrases,
      'tempoLeitura': tempoLeitura,
      'palavrasFrequentes': palavrasFrequentes
          .map((e) => {'palavra': e.key, 'frequencia': e.value})
          .toList(),
    };
  }

  factory AnaliseResultado.fromMap(Map<String, dynamic> map) {
    return AnaliseResultado(
      contagemCaracteres: map['contagemCaracteres'] ?? 0,
      contagemCaracteresSemEspacos: map['contagemCaracteresSemEspacos'] ?? 0,
      contagemPalavras: map['contagemPalavras'] ?? 0,
      contagemFrases: map['contagemFrases'] ?? 0,
      tempoLeitura: map['tempoLeitura'] ?? 0,
      palavrasFrequentes: (map['palavrasFrequentes'] as List?)
          ?.map<MapEntry<String, int>>((e) =>
          MapEntry(e['palavra'].toString(), e['frequencia'] as int))
          .toList() ??
          [],
    );
  }
}