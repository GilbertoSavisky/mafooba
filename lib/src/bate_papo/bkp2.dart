import 'package:cloud_firestore/cloud_firestore.dart';
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
  final _blocHome = HomeBloc();
  final _horaFormat = DateFormat('dd/MM/yy').add_Hm();
  Mensagens _mensagens;
  BatePapo _batePapo;
  Atleta _atleta = Atleta();
  Atleta _currentUser;
  List<BatePapo> _listaBatePapo = [];

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
      //floatingActionButton: buildSpeedDial(),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(2),
            height: 105,
            child: StreamBuilder<List<Atleta>>(
              stream: _blocHome.atleta,
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
                                radius: 32,
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BatePapoPage(contato, null, _currentUser)));
                                //Text(contato.nickName);
                              },
                            ),
                          ),
                          Container(
                            child: Text(
                              contato.nickName != '' ? contato.nickName : contato.nome,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                            alignment: Alignment.center,
                            width: 85,
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
            stream: _blocHome.filtrarCurrenteUserRemetente(widget.currentUser.uid),
            builder: (context, listaUserRementente){
              _listaBatePapo = [];

              return (listaUserRementente.hasData && listaUserRementente.connectionState == ConnectionState.active) ?
              ListBody(
                children: listaUserRementente.data.map((listaBatePapo){
                  return StreamBuilder<List<Atleta>>(
                    stream: _blocHome.getAtletaFiltro(listaBatePapo.destinatario),
                    builder: (context, listaAtleta){
                      return (listaAtleta.hasData && listaAtleta.connectionState == ConnectionState.active) ?
                      ListBody(
                        children: listaAtleta.data.map((atleta){
                          if(atleta != null){
                            _batePapo = listaBatePapo;
                            _batePapo.fotoUrl = atleta.fotoUrl;
                            _batePapo.nome = atleta.nome;
                            _batePapo.nickName = atleta.nickName;
                            _listaBatePapo.add(_batePapo);
                            print('${_batePapo.toMap()}');
                          }

                          return Container();
                        }).toList(),
                      ) : Container();
                    },
                  );
                }).toList(),
              ): Container();
            },
          ),

          StreamBuilder<List<BatePapo>>(
            stream: _blocHome.filtrarCurrenteUserDestinatario(widget.currentUser.uid),
            builder: (context, listaUserDestinatario){
              return (listaUserDestinatario.hasData && listaUserDestinatario.connectionState == ConnectionState.active) ?
              ListBody(
                children: listaUserDestinatario.data.map((listaBatePapo){
                  return StreamBuilder<List<Atleta>>(
                    stream: _blocHome.getAtletaFiltro(listaBatePapo.remetente),
                    builder: (context, listaAtleta){
                      return (listaAtleta.hasData && listaAtleta.connectionState == ConnectionState.active) ?
                      ListBody(
                        children: listaAtleta.data.map((atleta){
                          _batePapo = listaBatePapo;
                          _batePapo.fotoUrl = atleta.fotoUrl;
                          _batePapo.nome = atleta.nome;
                          _batePapo.nickName = atleta.nickName;
                          _listaBatePapo.add(_batePapo);
                          return Container();
                        }).toList(),
                      ) : Container();
                    },
                  );
                }).toList(),
              ) : Container();
            },
          ),

          ListBody(
            children: _listaBatePapo.map((batePapo){
              return StreamBuilder<List<Mensagens>>(
                stream: _blocHome.getMensagens(batePapo.documentId()),
                builder: (context, listaMsg){
                  if(listaMsg.hasData && listaMsg.connectionState == ConnectionState.active){

                    _batePapo.texto = listaMsg.data.first.texto;
                    _batePapo.imagem = listaMsg.data.first.imagem;
                    _batePapo.horario = listaMsg.data.first.horario;
                    _batePapo.sender = listaMsg.data.first.sender;
                    //_listaBatePapo.remove(_batePapo);
                    //_listaBatePapo.add(_batePapo);

                    //_listaBatePapo.add(_batePapo);
                  }
                  return Container();
                },
              );
            }).toList(),
          ),

          ListBody(
            children: _listaBatePapo.map((batePapo){
              print('-1-${batePapo.toMap()}');

              return Container();
            }).toList(),
          ),

          Expanded(
            child: ListView(
              children: _listaBatePapo.map((batePapoDestinatario){
                return (batePapoDestinatario != null) ?
                StreamBuilder<DocumentSnapshot>(
                  stream: _blocHome.getAtleta(batePapoDestinatario.remetente),
                  builder: (context, atletaRemetente){
                    return
                      StreamBuilder(
                        stream: _blocHome.getAtleta(batePapoDestinatario.destinatario),
                        builder: (context, atletaDestinatario){
                          return
                            StreamBuilder<List<Mensagens>>(
                              stream: null,//_blocHome.getMsg(batePapoDestinatario.documentId()),
                              builder: (context, mensagensRemetente){
                                //*****************************************************************************************************
                                if(atletaRemetente.hasData && atletaRemetente.connectionState == ConnectionState.active){
                                  _atleta = Atleta.fromMap(atletaRemetente.data);
                                }
                                //*****************************************************************************************************
                                return (atletaRemetente.hasData && atletaRemetente.connectionState == ConnectionState.active) ?
                                Card(
                                  margin: EdgeInsets.all(1),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 25,
                                      //backgroundImage: NetworkImage(_atleta.uid != widget.currentUser.uid ? _atleta.fotoUrl : atletaDestinatario?.data['fotoUrl']),
                                    ),

                                    title: Text(
                                      _atleta.uid != widget.currentUser.uid ?
                                      (_atleta.nickName != '' ?
                                      _atleta.nickName :
                                      _atleta.nome) :
                                      (atletaDestinatario.data['nickName']),

                                      overflow: TextOverflow.ellipsis,),

                                    subtitle: Text(mensagensRemetente.data != null ? mensagensRemetente.data.first.texto : ''),
                                    trailing: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(mensagensRemetente.hasData ? _horaFormat.format(mensagensRemetente.data.first.horario) : ''),
                                        //Container(
                                        //child: (
                                        //Image.asset(mensagensRemetente.data?.first.visualizado ? 'images/chuteira1.png' : 'images/chuteira2.png', width: 40,)
                                        //),
                                        //),
                                      ],
                                    ),
                                    onTap: (){
                                      Navigator.push(
                                        context,MaterialPageRoute(
                                          builder: (context) => BatePapoPage(_atleta, null, _currentUser)),
                                      );
                                    },
                                  ),
                                ) : Container(color: Colors.blue,);
                                //******************************************************************************************************
                              },
                            );
                        },
                      );
                  },
                ) : Container(color: Colors.yellow,);
              }).toList(),
            ),
          )
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

    Stream user = _blocHome.getAtleta(widget.currentUser.uid);
    user.map((data){
      _currentUser = Atleta.fromMap(data);
    }).toList();
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
