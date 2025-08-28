import 'package:flutter/material.dart';
import 'package:programacao_mobile_8A/pages/lista_receitas/pagina_lista_receitas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> minhasReceitas = [
      {
        "titulo": "Parmegiana de Beringela",
        "descricao": "Receita muito boa",
        "estaFavoritada": true,
      },
      {
        "titulo": "Parmegiana de Frango",
        "descricao": "Receita muito boa mesmo",
        "estaFavoritada": false,
      },
      {
        "titulo": "Lasanha",
        "descricao": "Hmmm, lasanha",
        "estaFavoritada": false,
      },
    ];
    return PaginaListaReceitas(dadosReceitas: minhasReceitas);
  }
}
