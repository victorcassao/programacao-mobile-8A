class Receita {
  String titulo;
  String descricao;
  bool estaFavoritada;
  List<String> ingredientes;

  Receita({
    required this.titulo,
    required this.descricao,
    required this.estaFavoritada,
    required this.ingredientes
  });

  factory Receita.fromJson(Map<String, dynamic> r) {
    return Receita(
      titulo: r["titulo"],
      descricao: r["descricao"],
      estaFavoritada: r["estaFavoritada"],
      ingredientes: r["ingredientes"]
    );
  }
}
