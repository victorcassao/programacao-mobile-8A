import 'package:flutter/material.dart';
import 'package:programacao_mobile_8A/data/receitas.dart';

class PaginaDetalhesReceita extends StatelessWidget {
  final Receita receita;

  const PaginaDetalhesReceita({required this.receita, super.key});

  @override
  Widget build(BuildContext context) {
    var ingredientesWidget = receita.ingredientes.map((i) => Text(i)).toList();
    return Scaffold(
      appBar: AppBar(title: Text(receita.titulo)),
      body: Padding(
        padding: EdgeInsetsGeometry.all(50),
        child: Column(
          children:
              [
                Text(receita.descricao),
                Center(
                  child: Text("Ingredientes", style: TextStyle(fontSize: 50)),
                ),
                ...ingredientesWidget,
                Center(
                  child: Text("Modo de preparo", style: TextStyle(fontSize: 50)),
                ),
              ],
        ),
      ),
    );
  }
}
