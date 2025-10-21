import 'package:flutter/material.dart';
import 'package:programacao_mobile_8A/data/receitas.dart';
import 'package:programacao_mobile_8A/services/receita_service.dart';

class PaginaCadastroReceita extends StatefulWidget {
  const PaginaCadastroReceita({super.key});

  @override
  State<PaginaCadastroReceita> createState() => _PaginaCadastroReceitaState();
}

class _PaginaCadastroReceitaState extends State<PaginaCadastroReceita> {
  final _formKey = GlobalKey<FormState>();
  final _receitaService = ReceitaService();

  // Campos do formulário
  String _titulo = '';
  String _descricao = '';
  int _porcoes = 1;
  int _tempoPreparo = 10;
  
  // Controllers para listas dinâmicas
  List<TextEditingController> _ingredientesControllers = [
    TextEditingController(),
  ];
  List<TextEditingController> _modoPreparoControllers = [
    TextEditingController(),
  ];

  // Categorias disponíveis
  final List<String> _categoriasDisponiveis = [
    'Vegetariana',
    'Vegana',
    'Aves',
    'Carnes',
    'Peixes',
    'Massas',
    'Italiana',
    'Brasileira',
    'Japonesa',
    'Mexicana',
    'Sobremesas',
    'Lanches',
    'Parmegiana',
  ];
  
  List<String> _categoriasSelecionadas = [];

  // Estado de loading
  bool _isLoading = false;

  @override
  void dispose() {
    // Liberar recursos dos controllers
    for (var controller in _ingredientesControllers) {
      controller.dispose();
    }
    for (var controller in _modoPreparoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildInputList(
    String label,
    List<TextEditingController> controllers,
    VoidCallback aoAdicionar,
    void Function(int) aoRemover
  ) {
    return Column(
      children: [
        Center(
          child: Text(
            label,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Divider(thickness: 2),
        SizedBox(height: 10),
        ...List.generate(
          controllers.length, 
          (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controllers[index],
                      decoration: InputDecoration(
                        labelText: '$label ${index + 1}',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                      enabled: !_isLoading,
                    )
                  ),
                  SizedBox(width: 8),
                  if (index == controllers.length - 1)
                    IconButton(
                      onPressed: _isLoading ? null : aoAdicionar, 
                      icon: Icon(Icons.add_circle),
                      color: Colors.green,
                      iconSize: 32,
                      tooltip: 'Adicionar',
                    ),
                  if (controllers.length > 1)
                    IconButton(
                      onPressed: _isLoading ? null : () => aoRemover(index), 
                      icon: Icon(Icons.remove_circle),
                      color: Colors.red,
                      iconSize: 32,
                      tooltip: 'Remover',
                    )
                ],
              ),
            );
          }
        ),
      ],
    );
  }

  void _adicionarIngrediente() {
    setState(() {
      _ingredientesControllers.add(TextEditingController());
    });
  }

  void _removerIngrediente(int index) {
    setState(() {
      _ingredientesControllers[index].dispose();
      _ingredientesControllers.removeAt(index);
    });
  }

  void _adicionarModoPreparo() {
    setState(() {
      _modoPreparoControllers.add(TextEditingController());
    });
  }

  void _removerModoPreparo(int index) {
    setState(() {
      _modoPreparoControllers[index].dispose();
      _modoPreparoControllers.removeAt(index);
    });
  }

  Future<void> _salvarReceita() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Validar se há pelo menos um ingrediente e um passo
      if (_ingredientesControllers.isEmpty || 
          _ingredientesControllers.every((c) => c.text.trim().isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Adicione pelo menos um ingrediente'),
            backgroundColor: Colors.orange,
          )
        );
        return;
      }

      if (_modoPreparoControllers.isEmpty || 
          _modoPreparoControllers.every((c) => c.text.trim().isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Adicione pelo menos um passo do modo de preparo'),
            backgroundColor: Colors.orange,
          )
        );
        return;
      }

      // Ativar estado de loading
      setState(() {
        _isLoading = true;
      });

      try {
        // Criar objeto Receita
        Receita novaReceita = Receita(
          titulo: _titulo,
          descricao: _descricao,
          estaFavoritada: false,
          porcoes: _porcoes,
          tempoPreparo: _tempoPreparo,
          categorias: _categoriasSelecionadas,
          ingredientes: _ingredientesControllers
              .map((c) => c.text.trim())
              .where((text) => text.isNotEmpty)
              .toList(),
          modoPreparo: _modoPreparoControllers
              .map((c) => c.text.trim())
              .where((text) => text.isNotEmpty)
              .toList(),
        );

        // Salvar no Firebase
        await _receitaService.adicionarReceita(novaReceita);

        // Mostrar mensagem de sucesso
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('Receita "${_titulo}" salva com sucesso!'),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            )
          );

          // Voltar para a tela anterior
          Navigator.pop(context);
        }
      } catch (e) {
        // Mostrar mensagem de erro
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('Erro ao salvar receita: $e'),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Tentar novamente',
                textColor: Colors.white,
                onPressed: _salvarReceita,
              ),
            )
          );
        }
      } finally {
        // Desativar loading
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar Nova Receita"),
        actions: [
          if (_isLoading)
            Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Card: Informações Básicas
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Informações Básicas",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                          Divider(),
                          SizedBox(height: 8),
                          
                          // Título da receita
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Título da Receita",
                              hintText: "Ex: Bolo de Chocolate",
                              prefixIcon: Icon(Icons.restaurant_menu),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty 
                                  ? 'Informe o título' 
                                  : null,
                            onSaved: (value) => _titulo = value!.trim(),
                            enabled: !_isLoading,
                          ),
                          SizedBox(height: 16),
                          
                          // Descrição
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Descrição",
                              hintText: "Uma breve descrição da receita",
                              prefixIcon: Icon(Icons.description),
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                            validator: (value) => value == null || value.trim().isEmpty
                                ? 'Informe a descrição'
                                : null,
                            onSaved: (value) => _descricao = value!.trim(),
                            enabled: !_isLoading,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Card: Detalhes
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Detalhes",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                          Divider(),
                          SizedBox(height: 8),
                          
                          // Quantidade de porções
                          Row(
                            children: [
                              Icon(Icons.restaurant, color: Colors.grey[600]),
                              SizedBox(width: 16),
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: _porcoes,
                                  decoration: InputDecoration(
                                    labelText: 'Porções',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: List.generate(20, (index) => index + 1)
                                      .map((e) => DropdownMenuItem(
                                        value: e, 
                                        child: Text('$e ${e == 1 ? "porção" : "porções"}')
                                      ))
                                      .toList(),
                                  onChanged: _isLoading ? null : (value) => setState(() {
                                    _porcoes = value!;
                                  }),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          
                          // Tempo de preparo
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.timer, color: Colors.grey[600]),
                                  SizedBox(width: 16),
                                  Text(
                                    "Tempo de preparo: $_tempoPreparo min",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold, 
                                      fontSize: 16
                                    ),
                                  ),
                                ],
                              ),
                              Slider(
                                value: _tempoPreparo.toDouble(),
                                min: 5,
                                max: 300,
                                divisions: 59,
                                label: '$_tempoPreparo min',
                                onChanged: _isLoading ? null : (value) {
                                  setState(() {
                                    _tempoPreparo = value.toInt();
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Card: Categorias
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Categorias",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                          Divider(),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _categoriasDisponiveis.map((categoria) {
                              final isSelected = _categoriasSelecionadas.contains(categoria);
                              return FilterChip(
                                label: Text(categoria),
                                selected: isSelected,
                                onSelected: _isLoading ? null : (selected) {
                                  setState(() {
                                    if (selected) {
                                      _categoriasSelecionadas.add(categoria);
                                    } else {
                                      _categoriasSelecionadas.remove(categoria);
                                    }
                                  });
                                },
                                selectedColor: Colors.blue[100],
                                checkmarkColor: Colors.blue[700],
                              );
                            }).toList(),
                          ),
                          if (_categoriasSelecionadas.isEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                "Selecione pelo menos uma categoria",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Card: Ingredientes
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: _buildInputList(
                        "Ingredientes",
                        _ingredientesControllers,
                        _adicionarIngrediente,
                        _removerIngrediente
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Card: Modo de preparo
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: _buildInputList(
                        "Modo de Preparo",
                        _modoPreparoControllers,
                        _adicionarModoPreparo,
                        _removerModoPreparo
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Botões
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isLoading 
                            ? null 
                            : () => Navigator.pop(context),
                          icon: Icon(Icons.cancel),
                          label: Text("Cancelar"),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _salvarReceita,
                          icon: _isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white
                                  ),
                                ),
                              )
                            : Icon(Icons.save),
                          label: Text(
                            _isLoading ? "Salvando..." : "Salvar Receita",
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
          
          // Overlay de loading em tela cheia
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          "Salvando receita...",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Aguarde um momento",
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}