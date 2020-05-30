import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:mafooba/app/modules/atleta/atleta_bloc.dart';
import 'package:mafooba/app/modules/atleta/atleta_page.dart';
import 'package:mafooba/app/modules/atleta/user_bloc.dart';
import 'package:mafooba/app/modules/equipe/equipe_bloc.dart';
import 'package:mafooba/app/modules/home/home_bloc.dart';
import 'package:mafooba/app/modules/models/atleta_model.dart';
import 'package:mafooba/app/modules/models/equipe_model.dart';

class AtletaHomePage extends StatefulWidget {
  final Equipe equipe;

  AtletaHomePage(this.equipe);
  @override
  _AtletaHomePageState createState() => _AtletaHomePageState();
}

class _AtletaHomePageState extends State<AtletaHomePage> {
  final _bloc = HomeBloc();
  final _blocEquipe = EquipeBloc();
  final _blocUsers = UserBloc();

  final _atletaController = TextEditingController();

  List<Atleta> _listaAtletas = [];
  ScrollController scrollController;
  bool dialVisible = true;

  @override
  void initState() {
    super.initState();
    _blocEquipe.setEquipe(widget.equipe);
    _listaAtletas = widget.equipe.atletas;
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Você tem certeza?'),
        content: new Text('Você irá voltar para a tela anterior'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Não'),
          ),
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: new Text('Sim'),
          ),
        ],
      ),
    ) ?? false;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Atletas"),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: StreamBuilder<List>(
            stream: _blocUsers.outUsers,
            builder: (context, atletas) {
              if (!atletas.hasData) return CircularProgressIndicator();
              return Column(
                children: <Widget>[
                  Container(
                     padding: EdgeInsets.only(left: 10, right: 10),
                     child: Row(
                       children: <Widget>[
                         Expanded(
                           child: TextField(
                             controller: _atletaController,
                             decoration: InputDecoration(
                               labelText: 'Atleta '
                             ),
                             onChanged: _blocUsers.buscaAtleta,
                           ),
                         ),
                         RaisedButton(
                           child: Text('Pesquisar'),
                           onPressed: (){},
                           color: Colors.green,
                         ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                      children: atletas.data.map((atleta){
                        print('.............${atleta['nome']}');

                        return
                          Dismissible(
                            key: Key('atleta.documentID'),
                          onDismissed: (direction) {
                            //_blocUsers.deleteAtleta(atleta.documentId());
                          },
                          child: !_verificaLista(atleta) ? Card(
                            child: CheckboxListTile(
                                //key: Key(atleta.uid),
                                secondary: atleta['fotoUrl'] != null ?
                                Container(
                                  child: CircleAvatar(backgroundImage: NetworkImage(atleta['fotoUrl']),
                                  ),
                                  height: 60,
                                  width: 60,
                                ) : Container(),
                                title: Text(
                                    atleta['nickName'] == null || atleta['nickName'] == '' ?
                                    atleta['nome'] : atleta['nickName']),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(atleta['fone'], style: TextStyle(fontSize: 13),),
                                  ],
                                ),
                                value: _verificaLista(atleta),
                                onChanged: (c){
                                  setState(() {
                                    print(c);
                                    if(c){
                                      //_blocEquipe.addAtleta(atleta);
                                    }
                                    else{
                                      //_blocEquipe.removeAtleta(atleta);
                                    }
                                  });
                                }
                            ),
                          ) : Container(),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }


  bool _verificaLista(var atleta){
    var ret = false;
    for(int i = 0; i < _listaAtletas.length; i++){
      if(_listaAtletas[i].uid == atleta.uid){
        return ret = true;
      }
      else ret = false;
    }
    return ret;
  }
}
