import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mafooba/app/modules/atleta/atleta_bloc.dart';
import 'package:mafooba/app/modules/atleta/atleta_home_page.dart';
import 'package:mafooba/app/modules/atleta/atleta_page.dart';
import 'package:mafooba/app/modules/bate_papo/bate_papo_home_page.dart';
import 'package:mafooba/app/modules/equipe/equipe_home_page.dart';
import 'package:mafooba/app/modules/home/home_bloc.dart';
import 'package:mafooba/app/modules/login/login_bloc.dart';
import 'package:mafooba/app/modules/models/atleta_model.dart';
import 'package:mafooba/app/shared/fundo_gradiente.dart';

class HomePage extends StatefulWidget {
  final String title;
  final Atleta atleta;
  const HomePage({Key key, this.title = "Mafooba", this.atleta}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  final LoginBloc _loginBloc = LoginBloc();
  final AtletaBloc _atletaBloc = AtletaBloc();
  final HomeBloc _homeBloc = HomeBloc();
  bool dialVisible = true;


  @override
  void initState(){
    super.initState();
    _atletaBloc.setAtleta(widget.atleta);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(widget.title),
            Text(' (My App of FootBall)', style: TextStyle(fontSize: 14),),
          ],
        ),
        elevation: 0,
        actions: <Widget>[
          StreamBuilder<Atleta>(
            stream: _loginBloc.outUser, //_homeBloc.getAtleta(widget.idAtleta),
            builder: (context, snapshot) {
              var _atleta;
              if(snapshot.hasData && snapshot.connectionState == ConnectionState.active){
                  _atleta = snapshot;
              }

              return Container(
                padding: EdgeInsets.only(right: 10),
                child: PopupMenuButton(
                  onSelected: (value) {
                    setState(() {
                      switch(value) {
                        case 1:
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => AtletaPage(snapshot.requireData) )
                          );
                          break;
                        case 2:
                          _loginBloc.deslogar();
                           _loginBloc.logar();
                      }
                    });
                  },
                  icon: Image.asset('images/bola.png'),padding: EdgeInsets.only(right: 15),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.edit_attributes, color: Colors.teal,),
                          Text(" Editar Perfil"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.autorenew, color: Colors.teal,),
                          Text(" Trocar de Conta"),
                        ],
                      ),
                    ),
                  ],          ),
              );
            }
          ),
        ],
      ),
      floatingActionButton: buildSpeedDial(
      ),
      body: Stack(
        children: <Widget>[
          FundoGradiente(),
          StreamBuilder(
            stream: _loginBloc.getImagem(),
            builder: (context, imagem){
              return imagem.hasData && imagem.connectionState == ConnectionState.active ?
              Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: FadeInImage.assetNetwork(
                    placeholder: 'images/214.gif',
                    image: imagem.data['imagem'],
                  ),
                ),
              )  :
              Center(
                child: CircularProgressIndicator(),
              );
            }
          ),
        ],
      ),
    );
  }

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      visible: dialVisible,
      backgroundColor: Colors.red,
//      marginBottom: 45,
//      marginRight: 300,
      child: Image.asset('images/bola.png', ),
      elevation: 10,
      curve: Curves.easeInBack,
      children: [

        SpeedDialChild(
          child: Icon(Icons.group_add, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EquipeHomePage()),
            );
          },
          label: 'Equipes',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.greenAccent,
        ),

        SpeedDialChild(
          child: Icon(Icons.person_add, color: Colors.white),
          backgroundColor: Colors.amber,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AtletaHomePage()),
            );
          },
          label: 'Atletas',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.amberAccent,
        ),

        SpeedDialChild(
          child: Icon(Icons.chat, color: Colors.white),
          backgroundColor: Colors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BatePapoHomePage()),
            );
          },
          label: 'Bate Papo',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.blueAccent,

        ),
      ],
    );
  }

}
