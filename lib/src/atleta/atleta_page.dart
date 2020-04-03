import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:mafooba/src/equipe/equipe_bloc.dart';
import 'package:mafooba/src/models/equipe_model.dart';

import '../models/atleta_model.dart';
import 'atleta_bloc.dart';

class AtletaPage extends StatefulWidget {
  AtletaPage(this.atleta);

  final Atleta atleta;

  @override
  _AtletaPageState createState() => _AtletaPageState();
}

class _AtletaPageState extends State<AtletaPage> {
  final _dateFormat = DateFormat("dd/MM/yyyy");
  TextEditingController _nomeController;
  TextEditingController _posicaoController;
  TextEditingController _emailController;
  TextEditingController _foneController;
  TextEditingController _fotoUrlController;
  TextEditingController _habilidadeController;
  TextEditingController _faltasController;

  final _bloc = AtletaBloc();

  @override
  void initState() {
    _bloc.setAtleta(widget.atleta);
    _nomeController = TextEditingController(text: widget.atleta.nome);
    _posicaoController = TextEditingController(text: widget.atleta.posicao);
//    _faltasController = TextEditingController(text: widget.atleta.faltas);
    _emailController = TextEditingController(text: widget.atleta.email);
    _foneController = TextEditingController(text: widget.atleta.fone);
    _fotoUrlController = TextEditingController(text: widget.atleta.fotoUrl);
    _habilidadeController = TextEditingController(text: widget.atleta.habilidade);
    super.initState();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _posicaoController.dispose();
    _emailController.dispose();
    _foneController.dispose();
    _fotoUrlController.dispose();
    _habilidadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Text("Editar Perfil de ${widget.atleta.nome}", style: TextStyle(color: Colors.white),),
        ),

      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: ListView(
            children: <Widget>[
              StreamBuilder(
                stream: _bloc.outFotoUrl,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container(color: Colors.green, width: 100,height: 100,);
                  return Center(
                    child: Image.network(snapshot.data, width: 110,
//                      onChanged: _bloc.setImagem,
                    ),heightFactor: 1.2,
                  );
                },
              ),
              Container(
                child: TextField(
                  decoration: InputDecoration(labelText: "Nome do Atleta", labelStyle: TextStyle(color: Colors.green)),
                  controller: _nomeController,
                  onChanged: _bloc.setNome,
                ),
              ),
              Container(height: 15),
              Container(
                child: TextField(
                  decoration: InputDecoration(labelText: "'Capitão' (adm. da equipe) "),
//                  controller: _localController,
//                  onChanged: _bloc.setCapitao,
                ),
              ),
              Container(height: 15),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(labelText: "Email"),
                        controller: _emailController,
                        onChanged: _bloc.setEmail,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(labelText: "Telefone"),
                        controller: _foneController,
                        onChanged: _bloc.setFone,
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 15),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(labelText: "Posição", hintText: 'zagueiro, meio'),
                        controller: _posicaoController,
                        onChanged: _bloc.setPosicao,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(labelText: "Total por time",hintText: '0'),
                        controller: _faltasController,
//                        onChanged: _bloc.setFaltas,
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 15),
              Container(
                child: TextField(
                  decoration: InputDecoration(labelText: "Valor da Cancha"),
                  controller: _habilidadeController,
                  onChanged: _bloc.setHabilidade,
                ),
              ),
              Container(height: 15),
              StreamBuilder(
                stream: _bloc.outIsGoleiro,
                initialData: true,
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
                          value: true,
                          onChanged: _bloc.setIsGoleiro,
                        ),
                      ),
                    ],
                  );
                },
              ),
              FloatingActionButton.extended (
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
