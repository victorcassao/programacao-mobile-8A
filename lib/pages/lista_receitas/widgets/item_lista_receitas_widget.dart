import 'package:flutter/material.dart';

class ItemListaReceita extends StatelessWidget {
  final String titulo;
  final String descricao;
  final bool estaFavoritada;
  final VoidCallback aoFavoritar;

  const ItemListaReceita({
    required this.titulo,
    required this.descricao,
    required this.estaFavoritada,
    required this.aoFavoritar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => print(titulo),
        leading: IconButton(
          icon: estaFavoritada ? Icon(Icons.star) : Icon(Icons.star_border),
          onPressed: aoFavoritar,
        ),
        title: Text(titulo),
        subtitle: Text(descricao),
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
