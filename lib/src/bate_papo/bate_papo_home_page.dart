import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:mafooba/src/bate_papo/bate_papo_page.dart';
import 'package:mafooba/src/equipe/equipe_page.dart';
import 'package:mafooba/src/home/home_bloc.dart';
import 'package:mafooba/src/models/atleta_model.dart';
import 'package:mafooba/src/models/bate_papo_model.dart';
import 'package:mafooba/src/models/equipe_model.dart';
import 'package:mafooba/src/atleta/atleta_page.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:mafooba/src/models/mensagens_model.dart';

class BatePapoHomePage extends StatefulWidget {
  final FirebaseUser currentUser;

  BatePapoHomePage(this.currentUser);

  @override
  _BatePapoHomePageState createState() => _BatePapoHomePageState();
}

class _BatePapoHomePageState extends State<BatePapoHomePage> {
  final _bloc = HomeBloc();
  final _horaFormat = DateFormat('yy/MM/dd').add_Hm();
  Atleta _atleta;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Lista de Bate-Papo'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                Color.fromARGB(-25, 13, 66, 13),
                Color.fromARGB(-43, 54, 172, 84),
              ])),
        ),
      ),
      floatingActionButton: buildSpeedDial(),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(7),
            height: 105,
            child: StreamBuilder<List<Atleta>>(
              stream: _bloc.atleta,
              builder: (context, snapshot) {

                if (!snapshot.hasData) return CircularProgressIndicator();

                return Container(
                  child: ListView(
                    children: snapshot.data.map((contato) {
                      return contato.uid != widget.currentUser.uid ? Column(
                        children: <Widget>[
                          Container(
                            child: GestureDetector(
                              child: CircleAvatar(
                                backgroundImage: contato.fotoUrl != null
                                    ? NetworkImage(contato.fotoUrl)
                                    : Container(),
                                radius: 35,
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BatePapoPage(contato, widget.currentUser)));
                                Text(contato.nickName);
                              },
                            ),
                          ),
                          Container(
                            child: Text(
                              contato.nickName,
                              overflow: TextOverflow.ellipsis,
                            ),
                            alignment: Alignment.center,
                            width: 115,
                            //color: Colors.yellow,
                          ),
                        ],
                      ) : Container();
                    }).toList(),
                    scrollDirection: Axis.horizontal,
                  ),
                );
              },
            ),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromARGB(-43, 14, 158, 60),
                  //Color.fromARGB(-43, 152, 249, 200),
                  //Color.fromARGB(-29, 144, 240, 244),
                  Color.fromARGB(-14, 194, 238, 240),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          StreamBuilder<List<BatePapo>>(
            stream: _bloc.filtrarBatePapo(currentID : widget.currentUser.uid),
            builder: (context, listaBate_papo) {
              //ListView mapea uma lista das msg filtradas
              return listaBate_papo.hasData ? Expanded(
                child: Container(
                  child: ListView(
                    children: listaBate_papo.data.map((listaBate_papoMAP) {

                      return Column(
                        children: <Widget>[

                          Dismissible(
                            key: Key(listaBate_papoMAP.documentId()),
                            onDismissed: (direction) {
                              _bloc.deleteChat(listaBate_papoMAP.documentId());
                            },

                            child: StreamBuilder(
                              stream: _bloc.getAtleta(listaBate_papoMAP.destinatarioUID),
                              builder: (context, atleta){
                                if(atleta.hasData)_atleta = Atleta.fromMap(atleta.data);
                                return atleta.hasData ? StreamBuilder<List<Mensagens>>(
                                  stream: _bloc.getMsg(listaBate_papoMAP.documentId()),
                                  builder: (context, msg){
                                    if(msg.hasData)
                                    return Card(
                                      elevation: 5,
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(atleta?.data['fotoUrl']),
                                          radius: 30,

                                        ),
                                        title: Text(atleta.data['nickName']),
                                        subtitle: Text(msg.data.first.texto, overflow: TextOverflow.ellipsis,),
                                        trailing: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(_horaFormat.format(msg.data.first.horario), style: TextStyle(fontSize: 12)),
                                            Card(
                                              color: Colors.green,
                                              child: !msg.data.first.visualizado ? Text('novo') : Text(''),
                                            ),
                                          ],
                                        ),
                                        onTap: (){
                                          Navigator.push(
                                            context,MaterialPageRoute(
                                              builder: (context) => BatePapoPage(_atleta, widget.currentUser)),
                                          );

                                        },
                                      ),
                                    );
                                    else return Container();
                                  },
                                ) : Container();

                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ) : Container();
            },
          ),
        ],
      ),
    );
  }

  ScrollController scrollController;

  bool dialVisible = true;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
  }

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  Widget buildBody() {
    return ListView.builder(
      controller: scrollController,
      itemCount: 30,
      itemBuilder: (ctx, i) => ListTile(title: Text('Item $i')),
    );
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      // child: Icon(Icons.add),
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      visible: dialVisible,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.group_add, color: Colors.white),
          backgroundColor: Colors.deepOrange,
          onTap: () {
            var equipe = Equipe()
              ..active = true
              ..horario = DateTime.now()
              ..nomeEquipe = ""
              ..estilo = ""
              ..local = ""
              ..foneCampo = ""
              ..totalJogadores = 0;

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EquipePage(equipe)),
            );
          },
          label: 'Equipes',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.deepOrangeAccent,
        ),
        SpeedDialChild(
          child: Icon(Icons.person_add, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () {
            var atleta = Atleta()
              ..nome = ""
              ..isGoleiro = false;

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AtletaPage(atleta: atleta)),
            );
          },
          label: 'Atletas',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.green,
        ),
        SpeedDialChild(
          child: Icon(Icons.chat, color: Colors.white),
          backgroundColor: Colors.blue,
          onTap: () => print('THIRD CHILD'),
          labelWidget: Container(
            color: Colors.blue,
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.all(6),
            child: Text('Custom Label Widget'),
          ),
        ),
      ],
    );
  }
}
