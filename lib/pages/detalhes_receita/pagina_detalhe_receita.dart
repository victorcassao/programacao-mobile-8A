import 'package:flutter/material.dart';
import 'package:programacao_mobile_8A/data/receitas.dart';

class PaginaDetalhesReceita extends StatelessWidget {
  final Receita receita;

  const PaginaDetalhesReceita({required this.receita, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(receita.titulo)),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Cabeçalho
                WidgetCabecalhoDetalheReceita(receita: receita),
                Divider(),
                SizedBox(height: 20),
                // Corpo
                // Informações gerais da receita
                WidgetInformacoesGeraisReceita(receita: receita),
                SizedBox(height: 20),
                // Ingredientes
                WidgetIngredientesReceita(receita: receita),
                SizedBox(height: 20),
                // Modo de preparo
                WidgetModoPreparoReceita(receita: receita),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WidgetCabecalhoDetalheReceita extends StatelessWidget {
  const WidgetCabecalhoDetalheReceita({super.key, required this.receita});

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
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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

class WidgetInformacoesGeraisReceita extends StatelessWidget {
  final Receita receita;
  const WidgetInformacoesGeraisReceita({required this.receita, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Informações da receita",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer, size: 20, color: Colors.grey),
                SizedBox(width: 8),
                Text('${receita.tempoPreparo} min'),
                SizedBox(width: 20),
                Icon(Icons.restaurant, size: 20, color: Colors.grey),
                SizedBox(width: 8),
                Text('${receita.porcoes} porções'),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: receita.categorias
                    .map(
                      (cat) => Chip(
                        label: Text(cat),
                        backgroundColor: Colors.orange[100],
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WidgetIngredientesReceita extends StatelessWidget {
  final Receita receita;

  const WidgetIngredientesReceita({required this.receita, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Text(
                "Ingredientes",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: receita.ingredientes.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.check_circle_outline),
                    title: Text(receita.ingredientes[index]),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WidgetModoPreparoReceita extends StatelessWidget {
  final Receita receita;
  const WidgetModoPreparoReceita({required this.receita, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Text(
                "Modo de preparo",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: receita.modoPreparo.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text('${index + 1}', style: TextStyle(fontSize: 20)),
                  ),
                  title: Text(receita.modoPreparo[index]),
                  contentPadding: EdgeInsets.all(4),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
