import 'package:flutter/material.dart';
import 'package:programacao_mobile_8A/data/receitas.dart';

class PaginaCadastroReceita extends StatefulWidget {
  final Function(Receita receita) onSalvar;
  const PaginaCadastroReceita(
    {
      required this.onSalvar,
      super.key
    }
  );

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
    VoidCallback aoAdicionar,
    void Function(int) aoRemover
  ) {
    return Column(
      children: [
        Center(
          child: Text(
            label,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        Divider(),
        SizedBox(height: 10),
        ...List.generate(
          controllers.length, 
          (index) {
            return Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controllers[index],
                    decoration: InputDecoration(
                      labelText: '$label  ${index + 1}'
                    ),
                  )
                ),
                SizedBox(width: 8),
                if (index == controllers.length - 1)
                  IconButton(
                    onPressed: aoAdicionar, 
                    icon: Icon(Icons.add),
                    color: Colors.green,
                  ),
                if (controllers.length > 1)
                  IconButton(
                    onPressed: () => aoRemover(index), 
                    icon: Icon(Icons.remove),
                    color: Colors.red,
                  )
              ],
            );
          }
        ),
      ],
    );
  }

  void _adicionarIngrediente(){
    setState(() {
      _ingredientesControllers.add(TextEditingController());
    });
  }

  void _removerIngrediente(int index){
    setState(() {
      _ingredientesControllers.removeAt(index);
    });
  }

  void _adicionarModoPreparo(){
    setState(() {
      _modoPreparoControllers.add(TextEditingController());
    });
  }

  void _removerModoPreparo(int index){
    setState(() {
      _modoPreparoControllers.removeAt(index);
    });
  }

  void _salvarReceita(){

    if (_formKey.currentState!.validate()){
      _formKey.currentState!.save();

      Receita novaReceita = Receita(
        titulo: _titulo,
        descricao: _descricao,
        estaFavoritada: false,
        porcoes: _porcoes,
        tempoPreparo: _tempoPreparo,
        categorias: [],
        ingredientes: _ingredientesControllers
          .map((c) => c.text)
          .toList(),
        modoPreparo: _modoPreparoControllers
          .map((c) => c.text)
          .toList(),
      );
      widget.onSalvar(novaReceita);
      Navigator.pop(context);
    }
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
              // Título da receita
              TextFormField(
                decoration: InputDecoration(labelText: "Título da Receita"),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o título' : null,
                onSaved: (value) => _titulo = value!,
              ),
              SizedBox(height: 16),
              // Descrição
              TextFormField(
                decoration: InputDecoration(labelText: "Descrição"),
                validator: (value) => value == null || value.isEmpty
                    ? 'Informe a descrição'
                    : null,
                onSaved: (value) => _descricao = value!,
              ),
              SizedBox(height: 16),
              // Quantidade de porções
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Porções'),
                items: List.generate(10, (index) => index + 1)
                    .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                    .toList(),
                onChanged: (value) => setState(() {
                  _porcoes = value!;
                }),
              ),
              SizedBox(height: 16),
              // Tempo de preparo
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tempo de preparo (min)",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Slider(
                    value: _tempoPreparo.toDouble(),
                    min: 1,
                    max: 300,
                    divisions: 299,
                    label: '${_tempoPreparo.toInt()}',
                    onChanged: (value) {
                      setState(() {
                        _tempoPreparo = value.toInt();
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Ingredientes
              _buildInputList(
                "Ingredientes",
                _ingredientesControllers,
                _adicionarIngrediente,
                _removerIngrediente
              ),
              SizedBox(height: 16),
              // Modo de preparo
              _buildInputList(
                "Modo de Preparo",
                _modoPreparoControllers,
                _adicionarModoPreparo,
                _removerModoPreparo
              ),
              SizedBox(height: 24),
              // Botão Salvar
              ElevatedButton(
                onPressed: _salvarReceita, 
                child: Text("Salvar")
              )
            ],
          ),
        ),
      ),
    );
  }
}
