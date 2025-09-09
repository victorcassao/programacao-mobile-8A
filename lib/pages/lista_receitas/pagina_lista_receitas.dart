import 'package:flutter/material.dart';
import 'package:programacao_mobile_8A/data/receitas.dart';
import 'package:programacao_mobile_8A/pages/lista_receitas/widgets/item_lista_receitas_widget.dart';

class PaginaListaReceitas extends StatelessWidget {
  final List<Map<String, dynamic>> dadosReceitas;
  final void Function(String titulo) aoAlternarFavorito;

  const PaginaListaReceitas(
    {
      required this.aoAlternarFavorito,
      required this.dadosReceitas, 
      super.key
    }
  );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dadosReceitas.length,
      itemBuilder: (context, index) {
        var dadosItem = dadosReceitas[index];
        Receita item = Receita.fromJson(dadosItem);
        return ItemListaReceita(
          receita: item,
          aoFavoritar: () => aoAlternarFavorito(item.titulo),
        );
      },
    );
  }
}
