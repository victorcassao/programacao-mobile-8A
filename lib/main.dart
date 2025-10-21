import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:programacao_mobile_8A/data/receitas.dart';
import 'package:programacao_mobile_8A/pages/cadastro_receita/pagina_cadastro_receita.dart';
import 'package:programacao_mobile_8A/pages/lista_receitas/pagina_lista_receitas.dart';
import 'package:programacao_mobile_8A/services/receita_service.dart';
import 'firebase_options.dart';

void main() async {
  // Garantir que os widgets estão inicializados
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
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
  final ReceitaService _receitaService = ReceitaService();

  void alternarFavoritoPorId(String id, bool valorAtual) async {
    try {
      await _receitaService.alternarFavorito(id, !valorAtual);
      
      final msg = !valorAtual
        ? 'Adicionado aos favoritos'
        : 'Removido dos favoritos';
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg))
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao favoritar: $e'))
        );
      }
    }
  }

  void adicionarNovaReceita(Receita receita) async {
    try {
      await _receitaService.adicionarReceita(receita);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Receita adicionada com sucesso!'))
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao adicionar receita: $e'))
        );
      }
    }
  }

  void excluirReceita(String id) async {
    try {
      await _receitaService.excluirReceita(id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Receita excluída com sucesso!'))
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao excluir receita: $e'))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Minhas Receitas")),
      body: IndexedStack(
        index: _indice,
        children: [
          // Todas as receitas
          StreamBuilder<List<Receita>>(
            stream: _receitaService.obterTodasReceitas(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              
              if (snapshot.hasError) {
                return Center(child: Text('Erro: ${snapshot.error}'));
              }
              
              final receitas = snapshot.data ?? [];
              
              if (receitas.isEmpty) {
                return Center(
                  child: Text(
                    'Nenhuma receita cadastrada',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }
              
              return PaginaListaReceitas(
                receitas: receitas,
                aoAlternarFavorito: alternarFavoritoPorId,
                aoExcluir: excluirReceita,
              );
            },
          ),
          
          // Receitas favoritas
          StreamBuilder<List<Receita>>(
            stream: _receitaService.obterReceitasFavoritas(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              
              if (snapshot.hasError) {
                return Center(child: Text('Erro: ${snapshot.error}'));
              }
              
              final receitas = snapshot.data ?? [];
              
              if (receitas.isEmpty) {
                return Center(
                  child: Text(
                    'Nenhuma receita favoritada',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }
              
              return PaginaListaReceitas(
                receitas: receitas,
                aoAlternarFavorito: alternarFavoritoPorId,
                aoExcluir: excluirReceita,
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) {
                return PaginaCadastroReceita();
              }
            )
          );
        }, 
        label: Text("Nova Receita"),
        icon: Icon(Icons.add, size: 50),
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