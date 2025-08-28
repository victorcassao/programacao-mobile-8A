import 'package:flutter/material.dart';
import 'package:programacao_mobile_8A/pages/lista_receitas/widgets/item_lista_receitas_widget.dart';

class PaginaListaReceitas extends StatelessWidget {
  final List<Map<String, dynamic>> dadosReceitas;

  const PaginaListaReceitas({required this.dadosReceitas, super.key});

  @override
  Widget build(BuildContext context) {
    // List<Widget> itensListaReceitas = [];
    // for (var item in dadosReceitas) {
    //   ItemListaReceita novaReceita = ItemListaReceita(
    //     titulo: item['titulo'],
    //     descricao: item['descricao'],
    //     estaFavoritada: item['estaFavoritada'],
    //   );
    //   itensListaReceitas.add(novaReceita);
    // }

    // List<Widget> itensListaReceitas = dadosReceitas
    //     .map(
    //       (e) => ItemListaReceita(
    //         titulo: e['titulo'],
    //         descricao: e['descricao'],
    //         estaFavoritada: e['estaFavoritada'],
    //       ),
    //     )
    //     .toList();

    // return Column(children: itensListaReceitas);
    // return ListView(
    //   padding: EdgeInsets.fromLTRB(50, 100, 5, 10),
    //   children: itensListaReceitas,
    // );
    return ListView.builder(
      padding: EdgeInsets.all(50),
      itemCount: dadosReceitas.length,
      itemBuilder: (context, index) {
        var item = dadosReceitas[index];
        return ItemListaReceita(
          titulo: item['titulo'],
          descricao: item['descricao'],
          estaFavoritada: item['estaFavoritada'],
        );
      },
    );
  }
}
