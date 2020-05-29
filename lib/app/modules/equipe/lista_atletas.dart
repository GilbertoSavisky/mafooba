import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mafooba/app/modules/atleta/atleta_home_page.dart';
import 'package:mafooba/app/modules/equipe/equipe_bloc.dart';
import 'package:mafooba/app/modules/home/home_bloc.dart';
import 'package:mafooba/app/modules/models/atleta_model.dart';
import 'package:mafooba/app/modules/models/equipe_model.dart';
import 'package:mafooba/app/shared/fundo_gradiente.dart';

class ListaAtletas extends StatefulWidget {

  final Equipe equipe;

  ListaAtletas(this.equipe);

  @override
  _ListaAtletasState createState() => _ListaAtletasState();
}

class _ListaAtletasState extends State<ListaAtletas> {

  final _equipeBloc = EquipeBloc();
  bool dialVisible = true;

  void initState(){
    super.initState();
    _equipeBloc.setEquipe(widget.equipe);
  }

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    _equipeBloc.outAtletas.listen((event) {
      setState(() {
        //print('..........+++++++++++++++++++++');
      });
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Column(
          children: <Widget>[
            StreamBuilder(
              stream: _equipeBloc.outAtletasRef,
              builder: (context, snapshot) {
                return snapshot.hasData && snapshot.connectionState == ConnectionState.active ?
                  Text('Total de ${snapshot.data.length} atletas') : Container();
              }
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Icon(MaterialCommunityIcons.check_circle_outline, size: 32, color: Colors.white,),
            onPressed: (){
              if(_equipeBloc.insertOrUpdate()){
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      floatingActionButton:
      SpeedDial(
        animatedIcon: AnimatedIcons.add_event,
        visible: dialVisible,
        children: [
          SpeedDialChild(
            child: Icon(Icons.group_add, color: Colors.white),
            backgroundColor: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AtletaHomePage(widget.equipe)),
              );
            },
            label: 'Add Atletas',
            labelStyle: TextStyle(fontWeight: FontWeight.w500),
            labelBackgroundColor: Colors.greenAccent,
          ),
           SpeedDialChild(

            child: Icon(widget.equipe.atletas.length == 0 ? Icons.delete_outline : Icons.delete_sweep, color: Colors.white),
            backgroundColor: Colors.green,
            onTap: () {
              widget.equipe.atletasRef.clear();
              widget.equipe.atletas.clear();
              _equipeBloc.setEquipe(widget.equipe);
            },
            label: 'Limpar lista',
            labelStyle: TextStyle(fontWeight: FontWeight.w500),
            labelBackgroundColor: Colors.greenAccent,
          ),
        ],

      ),

      body: Stack(
        children: <Widget>[
          FundoGradiente(),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: StreamBuilder<List<Atleta>>(
              stream: _equipeBloc.outAtletas,
              builder: (context, atletas) {
                return atletas.hasData && atletas.connectionState == ConnectionState.active ?
                  ListView(
                    children: atletas.data.map((atleta){
                      return Dismissible(
                        key: Key(atleta.documentId()),
                        onDismissed: (direction){
                          _equipeBloc.removeAtleta(atleta);
                        },
                        direction: DismissDirection.startToEnd,
                        child: Card(
                          margin: EdgeInsets.only(left: 10, top: 0,right: 10, bottom: 1),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: FadeInImage.assetNetwork(
                                fit: BoxFit.cover,
                                width: 40,
                                height: 40,
                                placeholder: "images/216.gif",
                                image: atleta.fotoUrl,
                              ),
                            ),
                            title: Text(atleta.nickName != '' ? atleta.nickName : atleta.nome),
                            subtitle: Text(atleta.posicao),
                            trailing: Column(
                              children: <Widget>[
                                Icon(MaterialCommunityIcons.gesture_swipe_right, color: Colors.deepOrange,),
                                Text('remover')
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList()
                ) : CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}
