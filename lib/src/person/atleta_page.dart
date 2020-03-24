import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:mafooba/src/models/atleta_model.dart';
import 'package:mafooba/src/person/atleta_bloc.dart';

class AtletaPage extends StatefulWidget {
  AtletaPage(this.atleta);

  final Atleta atleta;

  @override
  _AtletaPageState createState() => _AtletaPageState();
}

class _AtletaPageState extends State<AtletaPage> {
  final _dateFormat = DateFormat("dd/MM/yyyy");
  TextEditingController _nomeController;
  TextEditingController _emailController;
  TextEditingController _posicaoController;
  TextEditingController _habilidadeController;
  TextEditingController _foneController;
  final _bloc = AtletaBloc();

  @override
  void initState() {
    _bloc.setAtleta(widget.atleta);
    _nomeController = TextEditingController(text: widget.atleta.nome);
    _emailController = TextEditingController(text: widget.atleta.email);
    _posicaoController = TextEditingController(text: widget.atleta.posicao);
    _habilidadeController = TextEditingController(text: widget.atleta.habilidade);
    _foneController = TextEditingController(text: widget.atleta.fone);
    super.initState();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _posicaoController.dispose();
    _habilidadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Atleta"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              Container(
                child: TextField(
                  decoration: InputDecoration(labelText: "Nome do Atleta"),
                  controller: _nomeController,
                  onChanged: _bloc.setNome,
                ),
              ),
              Container(height: 20),
              Container(
                child: TextField(
                  decoration: InputDecoration(labelText: "email"),
                  controller: _emailController,
                  onChanged: _bloc.setEmail,
                ),
              ),
              Container(height: 20),
              Container(
                child: TextField(
                  decoration: InputDecoration(labelText: "Fone"),
                  controller: _foneController,
                  onChanged: _bloc.setFone,
                ),
              ),
              Container(height: 20),
              Container(
                child: TextField(
                  decoration: InputDecoration(labelText: "Habilidade"),
                  controller: _habilidadeController,
                  onChanged: _bloc.setHabilidade,
                ),
              ),
              Container(height: 20),
              Container(
                child: TextField(
                  decoration: InputDecoration(labelText: "Posição"),
                  controller: _posicaoController,
                  onChanged: _bloc.setPosicao,
                ),
              ),
              Container(height: 20),
              StreamBuilder(
                stream: _bloc.outIsGoleiro,
                initialData: false,
                builder: (context, snapshot) {
                  return Column(
                    children: <Widget>[
                      Text(
                        "Goleiro",
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
                  label: Text("Salvar"),
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