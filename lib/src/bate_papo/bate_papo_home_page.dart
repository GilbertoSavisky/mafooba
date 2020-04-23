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
            height: 110,
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
                              child: Container(
                                child: CircleAvatar(
                                  backgroundImage: contato.fotoUrl != null
                                      ? NetworkImage(contato.fotoUrl)
                                      : Container(),
                                  radius: 32,

                                ),
                                decoration:  ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32
                                    ),
                                    side: BorderSide(color: Colors.red, width: 2),
                                  ),

                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BatePapoPage(null, _currentUser)));
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
              return (listaUserRementente.hasData && listaUserRementente.connectionState == ConnectionState.active) ?
              StreamBuilder<List<BatePapo>>(
                stream: _blocHome.filtrarCurrenteUserDestinatario(widget.currentUser.uid),
                builder: (context, listaUserDestinatario) {
                  if(listaUserDestinatario.hasData && listaUserDestinatario.connectionState == ConnectionState.active){
                    _listaBatePapo.clear();
                    _listaBatePapo.addAll(listaUserDestinatario.data);
                    _listaBatePapo.addAll(listaUserRementente.data);
                  }
                  return (listaUserDestinatario.hasData && listaUserDestinatario.connectionState == ConnectionState.active) ?
                  Expanded(
                    child: ListView(
                      children: _listaBatePapo.map((user){
                        return StreamBuilder<List<Atleta>>(
                          stream: _blocHome.getAtletaFiltro(user.remetente),
                          builder: (context, atletaRemetente) {
                            return (atletaRemetente.hasData && atletaRemetente.connectionState == ConnectionState.active) ?
                            StreamBuilder<List<Atleta>>(
                              stream: _blocHome.getAtletaFiltro(user.destinatario),
                              builder: (context, atletaDestinatario) {


                                return (atletaDestinatario.hasData && atletaDestinatario.connectionState == ConnectionState.active) ?
                                Column(
                                  children: <Widget>[
                                    StreamBuilder<List<Mensagens>>(
                                      stream: _blocHome.getMensagens(user.documentId()),
                                      builder: (context, mensagens){
                                        if (atletaDestinatario.hasData && atletaDestinatario.connectionState == ConnectionState.active) {
                                          if (mensagens.hasData && mensagens.connectionState == ConnectionState.active) {
                                            _batePapo = user;
                                            _batePapo.texto = mensagens.data.first.texto;
                                            _batePapo.imagem = mensagens.data.first.imagem;
                                            _batePapo.sender = mensagens.data.first.sender;
                                            _batePapo.horario =
                                                mensagens.data.first.horario;
                                            if (atletaDestinatario.data.first.uid != widget.currentUser.uid) {
                                              _batePapo.fotoUrl = atletaDestinatario.data.first.fotoUrl;
                                              _batePapo.nome = atletaDestinatario.data.first.nome;
                                              _batePapo.nickName = atletaDestinatario.data.first.nickName;
                                            }
                                            if (atletaRemetente.data.first.uid != widget.currentUser.uid) {
                                              _batePapo.fotoUrl = atletaRemetente.data.first.fotoUrl;
                                              _batePapo.nome = atletaRemetente.data.first.nome;
                                              _batePapo.nickName = atletaRemetente.data.first.nickName;
                                            }
                                          }
                                        }
                                        return _batePapo != null ?
                                        Card(
                                          margin: EdgeInsets.all(1),
                                          child: ListTile(
                                            leading: Container(
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(_batePapo.fotoUrl),
                                                radius: 25,
                                              ),
                                              decoration:  ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(32
                                                  ),
                                                  side: BorderSide(color: Colors.green, width: 2),
                                                ),

                                              ),
                                            ),
                                            title: Text(_batePapo.nickName != '' ? _batePapo.nickName : _batePapo.nome, overflow: TextOverflow.ellipsis,),
                                            subtitle: Row(
                                              children: <Widget>[
                                                Icon(Icons.arrow_right, ),
                                                Text('${_batePapo.texto}', style: TextStyle(fontSize: 14, color: Colors.blue),overflow: TextOverflow.ellipsis,),
                                              ],
                                            ),
                                            trailing: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(_horaFormat.format(_batePapo.horario), style: TextStyle(fontSize: 11, color: Colors.blue),),
                                                Container(
                                                  child: (
                                                      Image.asset(!_batePapo.visualizado ? 'images/chuteira1.png' : 'images/chuteira3.png', width: 40,)
                                                  ),
                                                ),
                                              ],
                                            ),
                                            onTap: (){
                                              Navigator.push(
                                                context,MaterialPageRoute(
                                                  builder: (context) => BatePapoPage(user, _currentUser)),
                                              );
                                            },

                                          ),
                                        ) : Container();
                                      },
                                    ),
                                  ],
                                ) : Container();
                              },
                            ) : Container();
                          }
                        );
                      }).toList(),
                    ),
                  ) : Container();
                }
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
