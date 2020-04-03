import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:mafooba/src/atleta/atleta_home_page.dart';
import 'package:mafooba/src/chat/chat_home_page.dart';
import 'package:mafooba/src/chat/chat_page.dart';
import 'package:mafooba/src/equipe/equipe_home_page.dart';
import 'package:mafooba/src/models/atleta_model.dart';
import 'package:mafooba/src/atleta/atleta_page.dart';
import 'package:mafooba/src/shared/login.dart';
import 'home_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FirebaseUser _currentUser;

  final GlobalKey<ScaffoldState> _snackBar = GlobalKey<ScaffoldState>();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final _bloc = HomeBloc();
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
      appBar: AppBar(
        title: Text("Mafooba (My App of FootBall)"),
        actions: <Widget>[
          PopupMenuButton<WhyFarther>(
            onSelected: (WhyFarther result) {
              setState(() {

                if(result == WhyFarther.editarPerfil)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Login()),
                  );

              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<WhyFarther>>[
              const PopupMenuItem<WhyFarther>(
                value: WhyFarther.editarPerfil,
                child: Text('Editar Atleta'),
              ),
              const PopupMenuItem<WhyFarther>(
                value: WhyFarther.selfStarter,
                child: Text('Being a self-starter'),
              ),
              const PopupMenuItem<WhyFarther>(
                value: WhyFarther.tradingCharter,
                child: Text('Placed in charge of trading charter'),
              ),
            ],
            icon: Image.asset('images/bola.png'),padding: EdgeInsets.only(right: 15),
          ),
//          IconButton(onPressed: (){
//            Navigator.push(
//              context,
//              MaterialPageRoute(
//                  builder: (context) => Login()),
//            );
//          },
//          icon: Icon(Icons.menu, color: Colors.white,),)
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
                    //print(snapshot.hasData);
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
    googleSignIn.signOut();
    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
    FirebaseAuth.instance.onAuthStateChanged.listen((user){
      setState(() {
        if(_currentUser != null){
          return _currentUser;
        }
        else{
          print('setState login = ${user?.uid}');
          _currentUser = user;
        }
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
      Map<String, dynamic> dataUser = {
        "uid": user.uid,
        "email": user.email,
        "nome": user.displayName,
        "fotoUrl": user.photoUrl,
        "fone": user.phoneNumber
      };
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

      Firestore.instance.collection('atletas').document(user.uid).setData(dataUser);

//      return Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (context) => HomePage(_currentUser: user,)),
//      );


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
              MaterialPageRoute(builder: (context) => ChatHomePage()),
            );
          },
          label: 'Conversas',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.blueAccent,

        ),
      ],
    );
  }
}


enum WhyFarther { editarPerfil, selfStarter, tradingCharter }
