import 'package:flutter/material.dart';
import 'package:programacao_mobile_8A/data/receitas.dart';
import 'package:programacao_mobile_8A/pages/detalhes_receita/pagina_detalhe_receita.dart';

class ItemListaReceita extends StatelessWidget {
  final Receita receita;
  final VoidCallback aoFavoritar;

  const ItemListaReceita({
    required this.receita,
    required this.aoFavoritar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PaginaDetalhesReceita(
                receita: receita,
              )
            )
          );
        },
        leading: IconButton(
          icon: receita.estaFavoritada ? Icon(Icons.star) : Icon(Icons.star_border),
          onPressed: aoFavoritar,
        ),
        title: Text(receita.titulo),
        subtitle: Text(receita.descricao),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: Icon(Icons.edit), onPressed: () => {}),
            IconButton(icon: Icon(Icons.delete), onPressed: () => {}),
          ],
        ),
      ),
    );
  }
}
