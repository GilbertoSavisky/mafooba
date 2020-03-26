import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:mafooba/src/atleta/atleta_bloc.dart';
import 'package:mafooba/src/models/atleta_model.dart';

class AtletaPage extends StatefulWidget {
  AtletaPage(this.atleta);

  final Atleta atleta;

  @override
  _AtletaPageState createState() => _AtletaPageState();
}

class _AtletaPageState extends State<AtletaPage> {
  TextEditingController _nomeController;
  TextEditingController _emailController;
  TextEditingController _habilidadeController;
  final _bloc = AtletaBloc();

  @override
  void initState() {
    _bloc.setAtleta(widget.atleta);
    _nomeController = TextEditingController(text: widget.atleta.nome);
    _emailController = TextEditingController(text: widget.atleta.email);
    _habilidadeController = TextEditingController(text: widget.atleta.habilidade);
    super.initState();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _habilidadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Atletas"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: <Widget>[
              Container(
                child: TextField(
                  decoration: InputDecoration(labelText: "Nome do Atleta"),
                  controller: _nomeController,
                  onChanged: _bloc.setNome,
                ),
              ),
              Container(height: 20),Container(
                child: TextField(
                  decoration: InputDecoration(labelText: "Email"),
                  controller: _emailController,
                  onChanged: _bloc.setEmail,
                ),
              ),
              Container(height: 20),Container(
                child: TextField(
                  decoration: InputDecoration(labelText: "Habilidade do craque"),
                  controller: _habilidadeController,
                  onChanged: _bloc.setHabilidade,
                ),
              ),
              Container(height: 20),
              StreamBuilder(
                stream: _bloc.outIsGoleiro,
                initialData: true,
                builder: (context, snapshot) {
                  return Column(
                    children: <Widget>[
                      Text(
                        "Ativo",
                        textAlign: TextAlign.start,
                        style: TextStyle(),
                      ),
                      Center(
                        child: Switch(
                          value: snapshot.data,
                          onChanged: _bloc.setIsGoleiro,
                        ),
                      ),
                    ],
                  );
                },
              ),
              FloatingActionButton.extended(
                  label: Text("Salvar"),elevation: 5,
                  onPressed: () {
                    if (_bloc.insertOrUpdate()) {
                      Navigator.pop(context);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
