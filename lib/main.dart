import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ItemListaReceita(
          titulo: "Parmegiana de Beringela",
          descricao: "Receita muito boa",
          estaFavoritada: true,
        ),
        ItemListaReceita(
          titulo: "Parmegiana de Frango",
          descricao: "Receita muito boa mesmo",
          estaFavoritada: false,
        )
      ],
    );
  }
}

class ItemListaReceita extends StatelessWidget {

  final String titulo;
  final String descricao;
  final bool estaFavoritada;

  const ItemListaReceita(
    {
      required this.titulo,
      required this.descricao,
      required this.estaFavoritada,
      super.key
    }
  );

  @override
  Widget build(BuildContext context) {
    return Card(  
      child: ListTile(
        leading: IconButton(
          icon: estaFavoritada ? Icon(Icons.star) : Icon(Icons.star_border), 
          onPressed: () => {},
        ),
        title: Text(titulo),
        subtitle: Text(descricao),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => {},
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => {},
            ),
          ],
        ),
      ),
    );
  }
}
