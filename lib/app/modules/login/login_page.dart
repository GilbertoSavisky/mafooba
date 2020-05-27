import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mafooba/app/modules/home/home_page.dart';
import 'package:mafooba/app/modules/login/login_bloc.dart';
import 'package:mafooba/app/modules/models/atleta_model.dart';
import 'package:mafooba/app/shared/fundo_gradiente.dart';

class LoginPage extends StatefulWidget {
  final String title;
  const LoginPage({Key key, this.title = "Login"}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {

  final LoginBloc _loginBloc = LoginBloc();

  @override
  void initState(){
    super.initState();
    _loginBloc.outUser.listen((state){
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage(atleta: state))
      );
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
      ),
      body: StreamBuilder<Atleta>(
        stream: _loginBloc.outUser,
        builder: (context, user){
          return user.hasData && user.connectionState == ConnectionState.active ?
              Container()
           : Stack(
             children: <Widget>[
               FundoGradiente(),
               Container(
                padding: EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 60,
                      child: FloatingActionButton.extended(
                        onPressed: (){
                          _loginBloc.logar();
                        },
                        label: Text('Logar'),
                      ),
                    ),
                  ],
                ),
          ),
             ],
           );
        },
      ),
    );
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
            },
            child: new Text('Sim'),
          ),
        ],
      ),
    ) ?? false;
  }
}
