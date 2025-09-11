import 'package:flutter/material.dart';
import 'package:programacao_mobile_8A/data/receitas.dart';

class PaginaDetalhesReceita extends StatelessWidget {
  final Receita receita;

  const PaginaDetalhesReceita({required this.receita, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(receita.titulo)),
      body: Column(
        children: [
          // Cabeçalho
          WidgetCabecalhoDetalheReceita(receita: receita),
          // Corpo
        ],
      ),
    );
  }
}

class WidgetCabecalhoDetalheReceita extends StatelessWidget {
  const WidgetCabecalhoDetalheReceita({
    super.key,
    required this.receita,
  });

  final Receita receita;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  receita.titulo,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  receita.descricao,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          SizedBox(width: 50),
          Icon(
            receita.estaFavoritada ? Icons.star : Icons.star_border,
            size: 30,
          ),
        ],
      ),
    );
  }
}
