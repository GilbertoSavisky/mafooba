import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:mafooba/src/atleta/atleta_bloc.dart';
import 'package:mafooba/src/atleta/atleta_home_page.dart';
import 'package:mafooba/src/chat/chat_home_page.dart';
import 'package:mafooba/src/equipe/equipe_home_page.dart';
import 'package:mafooba/src/models/chat_model.dart';
import '../atleta/atleta_home_page.dart';
import '../atleta/atleta_page.dart';
import '../models/atleta_model.dart';
import 'home_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  Stream<DocumentSnapshot> _stream;
  FirebaseUser _currentUser;
  final GlobalKey<ScaffoldState> _snackBar = GlobalKey<ScaffoldState>();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final _bloc = HomeBloc();
  final _blocAtleta = AtletaBloc();
  final _dateFormat = DateFormat("dd/MM/yyyy");
  final _selection = null;
  Widget _buildBodyBack() => Container(
    decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Color.fromARGB(-12, 0, 156, 239),
              Color.fromARGB(-43, 152, 249, 200),
              Color.fromARGB(-43, 152, 249, 200),
              Color.fromARGB(-12, 0, 156, 239),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
        )
    ),
  );




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _snackBar,
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.all(15),
          child: Row(
            children: <Widget>[
              Text("Mafooba"),
              Text('   (My App of FootBall)', style: TextStyle(fontSize: 12),),
            ],
          ),
        ),
        actions: <Widget>[
          StreamBuilder<DocumentSnapshot>(
            stream: _bloc.getData(_currentUser?.uid),
            builder: (context, snapshot) {
              return Container(
                    padding: EdgeInsets.all(10),
                    child: PopupMenuButton<WhyFarther>(
                      onSelected: (WhyFarther result) {
                        setState(() {
                          if(result == WhyFarther.editarPerfil)  {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AtletaPage(documentSnapshot: snapshot.data,)),
                            );

                          }
                        });
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<WhyFarther>>[
                        const PopupMenuItem<WhyFarther>(
                          value: WhyFarther.editarPerfil,
                          child: Text('Editar meu perfil'),
                        ),
//                        const PopupMenuItem<WhyFarther>(
//                          value: WhyFarther.selfStarter,
//                          child: Text('Being a self-starter'),
//                        ),
//                        const PopupMenuItem<WhyFarther>(
//                          value: WhyFarther.tradingCharter,
//                          child: Text('Placed in charge of trading charter'),
//                        ),
                      ],
                      icon: Image.asset('images/bola.png'),padding: EdgeInsets.only(right: 15),
                    ),
                  );
            }
          ),
        ],
      ),

      floatingActionButton: buildSpeedDial(
      ),
      body: Stack(
        children: <Widget>[
          _buildBodyBack(),
          Container(
//            color: Colors.green[200],
            padding: EdgeInsets.only(top: 0),
            child: ListView(
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('home').snapshots(),
                  builder: (context, snapshot) {
                    return snapshot.hasData ? Center(
                      child: Container(
                       margin: EdgeInsets.only(top: 20),
//                        padding: EdgeInsets.all(20),
                        child: Image(image: NetworkImage(
                            snapshot.data.documents[0].data['imagem'])),
                      )

                    )  : Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ],
            ),
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
    _getUser();
    FirebaseAuth.instance.onAuthStateChanged.listen((user){
      setState(() {
        if(user == null)
          _getUser();
        _currentUser = user;
      });
    });

  }
  Future<FirebaseUser> _getUser() async {

    if(_currentUser != null){
      return _currentUser;
    }
    // Se for nulo tenta logar e retorna o user
    try{
      //Login com o Google, retorna a conta da pessoa logado no Google
      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      //Pega os dados de autenticacao do Google
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      //Passa as credenciais do Google para o AuthCredential do Firebase
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      //login no Firebase
      final AuthResult authResult = await FirebaseAuth.instance.signInWithCredential(credential);
      //Pega o user do Firebase
      final FirebaseUser user = authResult.user;

      Firestore.instance.collection('atletas').document(user.uid).snapshots().listen((event) {
        if(event.data == null)
        {
          var atleta = Atleta()
            ..uid = user.uid
            ..email= user.email
            ..nome= user.displayName
            ..fotoUrl= user.photoUrl
            ..fone = user.phoneNumber;

          _bloc.addAtleta(user.uid, atleta);

        }
      });

      if(user == null){
        _snackBar.currentState.showSnackBar(SnackBar(
          content: Text('Não foi possível fazer login. Tente novamente mais tarde!'),
          backgroundColor: Colors.red,
        ));
      }
      else {
        _snackBar.currentState.showSnackBar(SnackBar(
          content: Text('Bem vindo ${user.displayName}!'),
          backgroundColor: Colors.green,

        ));

      }
      return user;

    } catch(error){
      return null;
    }
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
              MaterialPageRoute(builder: (context) => ChatHomePage(_currentUser)),
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


enum WhyFarther { editarPerfil, selfStarter, tradingCharter }
