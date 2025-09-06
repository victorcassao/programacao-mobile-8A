import 'package:flutter/material.dart';
import 'package:programacao_mobile_8A/pages/lista_receitas/widgets/item_lista_receitas_widget.dart';

class PaginaListaReceitas extends StatefulWidget {
  final List<Map<String, dynamic>> dadosReceitas;

  const PaginaListaReceitas({required this.dadosReceitas, super.key});

  @override
  State<PaginaListaReceitas> createState() => _PaginaListaReceitasState();
}

class _PaginaListaReceitasState extends State<PaginaListaReceitas> {
  late List<Map<String, dynamic>> _receitas;
  
  @override
  void initState() {
    super.initState();
    _receitas = widget.dadosReceitas;
  }

  void alternarFavorito(int index){
    setState(() {
      _receitas[index]["estaFavoritada"] = !_receitas[index]["estaFavoritada"];
    });

    final msg = _receitas[index]["estaFavoritada"]
      ? 'Adicionado aos favoritos'
      : 'Removido dos favoritos';
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${ _receitas[index]["titulo"]} - $msg")
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _receitas.length,
      itemBuilder: (context, index) {
        var item = _receitas[index];
        return ItemListaReceita(
          titulo: item['titulo'],
          descricao: item['descricao'],
          estaFavoritada: item['estaFavoritada'],
          aoFavoritar: () => alternarFavorito(index),
        );
      },
    );
  }
}
