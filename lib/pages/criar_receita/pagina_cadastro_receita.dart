import 'package:flutter/material.dart';
import 'package:programacao_mobile_8A/data/receitas.dart';

class PaginaCadastroReceita extends StatefulWidget {
  final Function(Receita novaReceita) onSalvar;
  const PaginaCadastroReceita({required this.onSalvar, super.key});

  @override
  State<PaginaCadastroReceita> createState() => _PaginaCadastroReceitaState();
}

class _PaginaCadastroReceitaState extends State<PaginaCadastroReceita> {
  final _formKey = GlobalKey<FormState>();

  String _titulo = '';
  String _descricao = '';
  int _porcoes = 1;
  int _tempoPreparo = 10;
  List<TextEditingController> _ingredientesControllers = [
    TextEditingController(),
  ];
  List<TextEditingController> _modoPreparoControllers = [
    TextEditingController(),
  ];

  Widget _buildInputList(
    String label,
    List<TextEditingController> controllers,
    VoidCallback onAdd,
    void Function(int) onRemove,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            label,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Divider(),
        SizedBox(height: 8),
        ...List.generate(controllers.length, (index) {
          return Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controllers[index],
                  decoration: InputDecoration(labelText: '$label ${index + 1}'),
                ),
              ),
              const SizedBox(width: 8),
              if (index == controllers.length - 1)
                IconButton(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  color: Colors.green,
                ),
              if (controllers.length > 1)
                IconButton(
                  onPressed: () => onRemove(index),
                  icon: const Icon(Icons.remove),
                  color: Colors.red,
                ),
            ],
          );
        }),
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
      _modoPreparoControllers.removeAt(index);
    });
  }

  void _salvarReceita() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Receita nova = Receita(
        titulo: _titulo,
        descricao: _descricao,
        estaFavoritada: false,
        porcoes: _porcoes,
        tempoPreparo: _tempoPreparo.toInt(),
        categorias: [],
        ingredientes: _ingredientesControllers
            .map((c) => c.text)
            .where((t) => t.isNotEmpty)
            .toList(),
        modoPreparo: _modoPreparoControllers
            .map((c) => c.text)
            .where((t) => t.isNotEmpty)
            .toList(),
      );

      widget.onSalvar(nova);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    for (var c in _ingredientesControllers) {
      c.dispose();
    }
    for (var c in _modoPreparoControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastrar nova receita")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Entrada do titulo da receita
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Título da Receita',
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o título' : null,
                onSaved: (value) => _titulo = value!,
              ),
              SizedBox(height: 16),
              // Entrada da descrição da receita
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Informe a descrição'
                    : null,
                onSaved: (value) => _descricao = value!,
              ),
              SizedBox(height: 16),
              // Entrada da quantidade porções
              DropdownButtonFormField<int>(
                value: _porcoes,
                decoration: const InputDecoration(labelText: 'Porções'),
                items: List.generate(10, (index) => index + 1)
                    .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                    .toList(),
                onChanged: (value) => setState(() => _porcoes = value!),
              ),
              SizedBox(height: 16),
              // Entrada do tempo de preparo
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tempo de Preparo (min)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _tempoPreparo.toDouble(),
                    min: 1,
                    max: 300,
                    divisions: 299,
                    label: '${_tempoPreparo.toInt()} min',
                    onChanged: (value) {
                      setState(() {
                        _tempoPreparo = value.toInt();
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Entrada de ingredientes
              _buildInputList(
                'Ingredientes',
                _ingredientesControllers,
                _adicionarIngrediente,
                _removerIngrediente,
              ),
              SizedBox(height: 25),
              // Entrada de ingredientes
              _buildInputList(
                'Modo de Preparo',
                _modoPreparoControllers,
                _adicionarModoPreparo,
                _removerModoPreparo,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _salvarReceita,
                child: const Text('Salvar Receita'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
