import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
  final GlobalKey<ScaffoldState> _snackBar = GlobalKey<ScaffoldState>();
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
      //onWillPop: _onBackPressed,
      child: Scaffold(
        key: _snackBar,
        appBar: AppBar(
          title: Text("Atletas"),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: StreamBuilder<List<Atleta>>(
            stream: _bloc.atleta,
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
                        return
                          Card(
                            color: _verificaLista(atleta) ? Colors.grey[300] : Colors.white,
                            child: CheckboxListTile(
                                key: Key(atleta.uid),
                                secondary: atleta.fotoUrl != null ?
                                Container(
                                  child: CircleAvatar(backgroundImage: NetworkImage(atleta.fotoUrl),
                                  ),
                                  height: 60,
                                  width: 60,
                                ) : Container(),
                                title: Text(
                                    atleta.nickName == null || atleta.nickName == '' ?
                                    atleta.nome : atleta.nickName),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(atleta.posicao, style: TextStyle(fontSize: 13),),
                                    Text(atleta.fone, style: TextStyle(fontSize: 13),),
                                  ],
                                ),
                                value: _verificaLista(atleta),
                                onChanged: (c){
                                  setState(() {
                                    if(c){
                                      _blocEquipe.addAtleta(atleta);
                                      Flushbar(
                                        title: '${atleta.nickName != '' ? atleta.nickName : atleta.nome}',
                                        message: 'Adicionado à sua lista de atletas',
                                        icon: Icon(FontAwesome.angellist, color: Colors.white, size: 35,),//  Icon(Icons.check, color: Colors.red,),
                                        duration: Duration(seconds: 2),
                                        margin: EdgeInsets.all(12),
                                        borderRadius: 8,
                                        backgroundColor: Colors.green,
                                        showProgressIndicator: true,
                                        progressIndicatorBackgroundColor: Colors.blueGrey,
                                        mainButton: FlatButton(
                                          onPressed: (){},
                                          child: Icon(FontAwesome.check, color: Colors.white,),
                                        ),
                                      )..show(context);

                                    }
                                    else{
                                      _blocEquipe.removeAtleta(atleta);
                                    }
                                  });
                                }
                            ),
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


  bool _verificaLista(Atleta atleta){
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