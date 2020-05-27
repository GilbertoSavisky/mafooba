
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {


  final GoogleSignIn googleSignIn = GoogleSignIn();


  FirebaseUser _currentUser;
  //exibir snackbar
  final GlobalKey<ScaffoldState> _snackBar = GlobalKey<ScaffoldState>();
  @override
  // Chama essa função stream cada vez que mudar o usuario, sendo um usuario ou nulo
  void initState() {
    super.initState();
    FirebaseAuth.instance.signOut();
    _currentUser = null;
    FirebaseAuth.instance.onAuthStateChanged.listen((user){
      setState(() {
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

      return user;


    } catch(error){
      return null;
    }
  }

  void verificaUserLogado()async{
    final FirebaseUser user = await _getUser();
  }


  @override
  Widget build(BuildContext context) {
    verificaUserLogado();
    return Scaffold(
      key: _snackBar,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          iconSize: 30,
          onPressed: (){
          },
        ),
        title: Text('Mafooba', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            iconSize: 30,
            onPressed: (){
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: FlatButton(
              child: Text('desclogar'),
              color: Colors.red,
              onPressed: (){
                FirebaseAuth.instance.signOut();
              },
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: FlatButton(
              child: Text('logar'),
              color: Colors.blue,
              onPressed: (){},
            ),
          ),
        ],
      ),
    );
  }
}
