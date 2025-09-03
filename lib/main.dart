import 'package:flutter/material.dart';
import 'package:programacao_mobile_8A/pages/lista_receitas/pagina_lista_receitas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReceitasApp',
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      //   theme: ThemeData(
      //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange)
      //   ),
      //   darkTheme: ThemeData(
      //     colorScheme: ColorScheme.fromSeed(
      //       seedColor: Colors.deepOrange,
      //       brightness: Brightness.dark,
      //     )
      //   ),
      //   themeMode: ThemeMode.light,
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
  List<Map<String, dynamic>> minhasReceitas = [
    {
      "titulo": "Parmegiana de Beringela",
      "descricao": "Receita muito boa",
      "estaFavoritada": true,
    },
    {
      "titulo": "Parmegiana de Frango",
      "descricao": "Receita muito boa mesmo",
      "estaFavoritada": false,
    },
    {
      "titulo": "Lasanha",
      "descricao": "Hmmm, lasanha",
      "estaFavoritada": false,
    },
  ];

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
        content: Text("${ minhasReceitas[idx]['titulo']} - $msg"),
        duration: Duration(seconds: 2),
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
      PaginaListaReceitas(dadosReceitas: todasReceitas, aoAlternarFavorito: alternarFavoritoPorTitulo,),
      PaginaListaReceitas(dadosReceitas: favoritas, aoAlternarFavorito: alternarFavoritoPorTitulo,),
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Minhas receitas'), elevation: 20),
      body: IndexedStack(index: _indice, children: telas),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indice,
        onTap: (i) => setState(() => _indice = i),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_outlined),
            label: "Todas"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_sharp),
            label: "Favoritas"
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => print("Adicionar nova receita"),
        label: Text('Nova Receita'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
