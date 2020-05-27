import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:mafooba/app/modules/atleta/atleta_bloc.dart';
import 'package:mafooba/app/modules/atleta/atleta_page.dart';
import 'package:mafooba/app/modules/equipe/equipe_bloc.dart';
import 'package:mafooba/app/modules/home/home_bloc.dart';
import 'package:mafooba/app/modules/models/atleta_model.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mafooba/app/modules/models/equipe_model.dart';

class AtletaHomePage extends StatefulWidget {
  final Equipe equipe;

  AtletaHomePage(this.equipe);
  @override
  _AtletaHomePageState createState() => _AtletaHomePageState();
}

class _AtletaHomePageState extends State<AtletaHomePage> {
  final _bloc = HomeBloc();
  final _atletaBloc = AtletaBloc();
  final _equipeBloc = EquipeBloc();

  final _dateFormat = DateFormat("dd/MM/yyyy");
  final _atletaController = TextEditingController();

  List<Atleta> _listaAtletas = [];
  List _listaAtletasRef = [];
  ScrollController scrollController;
  bool dialVisible = true;

  @override
  void initState() {
    super.initState();
    _listaAtletasRef = widget.equipe.atletasRef;
    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Atletas"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: StreamBuilder<List<Atleta>>(
          stream: _bloc.atleta,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();

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
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {

                        return Dismissible(
                        key: Key(snapshot.data[index].documentId()),
                        onDismissed: (direction) {
                          _bloc.deleteAtleta(snapshot.data[index].documentId());
                        },
                        child: Card(
                          child: CheckboxListTile(
                            key: Key(snapshot.data[index].uid),
                            secondary: snapshot.data[index].fotoUrl != null ?
                            Container(
                              child: CircleAvatar(backgroundImage: NetworkImage(snapshot.data[index].fotoUrl),
                              ),
                              height: 60,
                              width: 60,
                            ) : Container(),
                            title: Text(
                              snapshot.data[index].nickName == null || snapshot.data[index].nickName == '' ?
                                snapshot.data[index].nome : snapshot.data[index].nickName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(snapshot.data[index].fone, style: TextStyle(fontSize: 13),),
                              ],
                            ),
                            value: _verificaLista(snapshot.data[index]),
                            onChanged: (c){
                              setState(() {
                                _atualizarListaAtletas(c, snapshot.data[index]);
                              });
                            }
                          ),
                        ),
                      );
                    }),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }


  bool _verificaLista(Atleta atleta){
    var ret = false;
    for(int i = 0; i < _listaAtletas.length; i++){
      if(_listaAtletas[i].uid == atleta.uid)
        return ret = true;
      else ret = false;
    }
    return ret;
  }

  void _atualizarListaAtletas(bool c, Atleta atleta){
    if(c == true) {
      _listaAtletas.add(atleta);
      _listaAtletas.forEach((f){
        if(!_listaAtletasRef.contains(f.referencia)){
          _listaAtletasRef.add(f.referencia);
        }
      });
    }
    else {
      for(int i = 0; i < _listaAtletas.length; i++){
        if(_listaAtletas[i].uid == atleta.uid) {
          _listaAtletas.removeAt(i);
        }
      }for(int i = 0; i < _listaAtletasRef.length; i++){
        if(_listaAtletasRef[i].path == atleta.referencia.path) {
          _listaAtletasRef.removeAt(i);
        }
      }
    }
    _listaAtletasRef.forEach((f){
      print(f.path);
    });
  }


  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }
}
