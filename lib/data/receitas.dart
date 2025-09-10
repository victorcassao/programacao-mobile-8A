class Receita {
  String titulo;
  String descricao;
  bool estaFavoritada;
  int porcoes;
  int tempoPreparo;
  List<String> categorias;
  List<String> ingredientes;
  List<String> modoPreparo;

  Receita({
    required this.titulo,
    required this.descricao,
    required this.estaFavoritada,
    required this.porcoes,
    required this.tempoPreparo,
    required this.categorias,
    required this.ingredientes,
    required this.modoPreparo
  });

  factory Receita.fromJson(Map<String, dynamic> r) {
    return Receita(
      titulo: r["titulo"],
      descricao: r["descricao"],
      estaFavoritada: r["estaFavoritada"],
      porcoes: r["porcoes"],
      tempoPreparo: r["tempoPreparo"],
      categorias: r["categorias"],
      ingredientes: r["ingredientes"],
      modoPreparo: r["modoPreparo"]
    );
  }
}

