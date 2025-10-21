import 'package:flutter/material.dart';
import 'package:programacao_mobile_8A/data/receitas.dart';
import 'package:programacao_mobile_8A/pages/lista_receitas/widgets/item_lista_receitas_widget.dart';

class PaginaListaReceitas extends StatelessWidget {
  final List<Receita> receitas;
  final Function(String id, bool valorAtual) aoAlternarFavorito;
  final Function(String id) aoExcluir;

  const PaginaListaReceitas({
    required this.receitas, 
    required this.aoAlternarFavorito,
    required this.aoExcluir,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: receitas.length,
      itemBuilder: (context, index) {
        final receita = receitas[index];

        return ItemListaReceita(
          receita: receita,
          aoFavoritar: () => aoAlternarFavorito(
            receita.id!, 
            receita.estaFavoritada
          ),
          aoExcluir: () => _confirmarExclusao(context, receita),
        );
      },
    );
  }

  void _confirmarExclusao(BuildContext context, Receita receita) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Excluir Receita'),
        content: Text('Deseja realmente excluir "${receita.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              aoExcluir(receita.id!);
              Navigator.pop(context);
            },
            child: Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}