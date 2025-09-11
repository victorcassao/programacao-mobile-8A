import 'package:flutter/material.dart';
import 'package:programacao_mobile_8A/pages/lista_receitas/pagina_lista_receitas.dart';
import 'dados_receitas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReceitasApp', 
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _indice = 0;

  void alternarFavoritoPorTitulo(String titulo){

    final idx = minhasReceitas.indexWhere((e) => e['titulo'] == titulo);
    setState(() {
      minhasReceitas[idx]["estaFavoritada"] = !minhasReceitas[idx]["estaFavoritada"];
    });

    final msg = minhasReceitas[idx]["estaFavoritada"]
      ? 'Adicionado aos favoritos'
      : 'Removido dos favoritos';
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${ minhasReceitas[idx]["titulo"]} - $msg")
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final todasReceitas = minhasReceitas;
    final favoritas = minhasReceitas
      .where((e) => e['estaFavoritada'] == true)
      .toList();
    
    List<Widget> telas = [
      PaginaListaReceitas(dadosReceitas: todasReceitas, aoAlternarFavorito: alternarFavoritoPorTitulo),
      PaginaListaReceitas(dadosReceitas: favoritas, aoAlternarFavorito: alternarFavoritoPorTitulo),
    ];
    return Scaffold(
      appBar: AppBar(title: Text("Minhas Receitas")),
      body: IndexedStack(
        index: _indice,
        children: telas,
        ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: null, 
        label: Text("Nova Receita"),
        icon: Icon(Icons.add, size: 50,),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (i) => setState(() => _indice = i),
        currentIndex: _indice,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_outlined),
            label: 'Todas'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_sharp),
            label: 'Favoritas'
          )
        ]
      ),
    );
  }
}
