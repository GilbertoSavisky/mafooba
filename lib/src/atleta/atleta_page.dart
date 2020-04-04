import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:mafooba/src/home/home_bloc.dart';

import '../models/atleta_model.dart';
import 'atleta_bloc.dart';

class AtletaPage extends StatefulWidget {
  AtletaPage(this.atleta);

  Atleta atleta;

  @override
  _AtletaPageState createState() => _AtletaPageState();
}

class _AtletaPageState extends State<AtletaPage> {
  final _dateFormat = DateFormat("dd/MM/yyyy");
  TextEditingController _nomeController;
  TextEditingController _nickNameController;
  TextEditingController _posicaoController;
  TextEditingController _emailController;
  TextEditingController _foneController;
  TextEditingController _fotoUrlController;
  TextEditingController _habilidadeController;
  TextEditingController _faltasController;
  bool _isGoleiroController;



  final _bloc = AtletaBloc();
  final _blocHome = HomeBloc();

  @override
  void initState() {


    _nomeController = TextEditingController(text: widget.atleta.nome);
    _nickNameController = TextEditingController(text: widget.atleta.nickName);
    _posicaoController = TextEditingController(text: widget.atleta.posicao);
    _faltasController = TextEditingController(text: widget.atleta.faltas.toString());
    _emailController = TextEditingController(text: widget.atleta.email);
    _foneController = TextEditingController(text: widget.atleta.fone);
    _fotoUrlController = TextEditingController(text: widget.atleta.fotoUrl);
    _habilidadeController = TextEditingController(text: widget.atleta.habilidade);
    _isGoleiroController = widget.atleta.isGoleiro;
    _bloc.setAtleta(widget.atleta);

    super.initState();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _nickNameController.dispose();
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
          title: Text("Editar Perfil de \n${widget.atleta.nome}", style: TextStyle(color: Colors.white),),
        ),

      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance.collection('atletas').document(widget.atleta.uid).snapshots(),
            builder: (context, snapshot) {
//              widget.atleta
//                ..uid = snapshot.data.data['uid'];
//
              return ListView(
                children: <Widget>[
                  StreamBuilder(
                    stream: _bloc.outFotoUrl,
                    builder: (context, snapshot) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: InkWell(
                            child: CircleAvatar(
                              backgroundImage: snapshot.hasData ? NetworkImage(snapshot.data) : AssetImage('images/bola.png'),
                              maxRadius: 55,
                            ),
                            onTap: (){

                            },
                          ),
                        ),
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
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(labelText: "Apelido"),
                            controller: _nickNameController,
                            onChanged: _bloc.setNickName,
                          ),
                        ),
                        StreamBuilder(
                          stream: _bloc.outIsGoleiro,
                          initialData: _isGoleiroController,
                          builder: (context, snapshot) {
                            return Row(
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

                      ],
                    ),
                  ),
                  Container(
                    child: TextField(
                      decoration: InputDecoration(labelText: "Email"),
                      controller: _emailController,
                      onChanged: _bloc.setEmail,
                    ),
                  ),
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
                  Container(
                    child: TextField(
                      decoration: InputDecoration(labelText: "Valor da Cancha"),
                      controller: _habilidadeController,
                      onChanged: _bloc.setHabilidade,
                    ),
                  ),
                  FloatingActionButton.extended (
                      label: Text("Salvar"),elevation: 5,
                      onPressed: () {
                        if (_bloc.insertOrUpdate()) {
                          Navigator.pop(context);
                        }
                      }),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
