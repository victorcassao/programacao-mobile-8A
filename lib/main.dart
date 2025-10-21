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
  
  // Keys para controlar o refresh dos FutureBuilders
  Key _todasReceitasKey = UniqueKey();
  Key _receitasFavoritasKey = UniqueKey();

  void _atualizarListas() {
    setState(() {
      _todasReceitasKey = UniqueKey();
      _receitasFavoritasKey = UniqueKey();
    });
  }

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
        
        // Atualizar as listas após favoritar
        _atualizarListas();
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
        
        // Atualizar as listas após adicionar
        _atualizarListas();
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
        
        // Atualizar as listas após excluir
        _atualizarListas();
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
      appBar: AppBar(
        title: Text("Minhas Receitas"),
        actions: [
          // Botão de refresh manual
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _atualizarListas,
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: IndexedStack(
        index: _indice,
        children: [
          // Todas as receitas
          FutureBuilder<List<Receita>>(
            key: _todasReceitasKey,
            future: _receitaService.obterTodasReceitas(),
            builder: (context, snapshot) {
              // Estado: Carregando
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              
              // Estado: Erro
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red),
                      SizedBox(height: 16),
                      Text(
                        'Erro ao carregar receitas',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _atualizarListas,
                        icon: Icon(Icons.refresh),
                        label: Text('Tentar Novamente'),
                      ),
                    ],
                  ),
                );
              }
              
              // Estado: Sucesso
              final receitas = snapshot.data ?? [];
              
              if (receitas.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.restaurant_menu, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Nenhuma receita cadastrada',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Toque no botão + para adicionar',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
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
          FutureBuilder<List<Receita>>(
            key: _receitasFavoritasKey,
            future: _receitaService.obterReceitasFavoritas(),
            builder: (context, snapshot) {
              // Estado: Carregando
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              
              // Estado: Erro
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red),
                      SizedBox(height: 16),
                      Text(
                        'Erro ao carregar favoritas',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _atualizarListas,
                        icon: Icon(Icons.refresh),
                        label: Text('Tentar Novamente'),
                      ),
                    ],
                  ),
                );
              }
              
              // Estado: Sucesso
              final receitas = snapshot.data ?? [];
              
              if (receitas.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star_border, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Nenhuma receita favoritada',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Toque na estrela para favoritar receitas',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
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
        onPressed: () async {
          // Navega e espera retorno
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PaginaCadastroReceita(),
            )
          );
          
          // Quando voltar, atualiza as listas
          _atualizarListas();
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