class Receita {
  String? id; // ID do documento no Firestore
  String titulo;
  String descricao;
  bool estaFavoritada;
  int porcoes;
  int tempoPreparo;
  List<String> categorias;
  List<String> ingredientes;
  List<String> modoPreparo;

  Receita({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.estaFavoritada,
    required this.porcoes,
    required this.tempoPreparo,
    required this.categorias,
    required this.ingredientes,
    required this.modoPreparo,
  });

  factory Receita.fromJson(Map<String, dynamic> r) {
    return Receita(
      id: r['id'],
      titulo: r["titulo"], 
      descricao: r["descricao"], 
      estaFavoritada: r["estaFavoritada"], 
      porcoes: r["porcoes"], 
      tempoPreparo: r["tempoPreparo"], 
      categorias: List<String>.from(r["categorias"] ?? []), 
      ingredientes: List<String>.from(r["ingredientes"] ?? []), 
      modoPreparo: List<String>.from(r["modoPreparo"] ?? [])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // Não incluímos o 'id' no toJson pois ele é gerado pelo Firestore
      "titulo": titulo,
      "descricao": descricao,
      "estaFavoritada": estaFavoritada,
      "porcoes": porcoes,
      "tempoPreparo": tempoPreparo,
      "categorias": categorias,
      "ingredientes": ingredientes,
      "modoPreparo": modoPreparo
    };
  }
}