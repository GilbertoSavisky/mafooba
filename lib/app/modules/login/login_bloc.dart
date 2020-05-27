import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mafooba/app/modules/home/home_bloc.dart';
import 'package:mafooba/app/modules/models/atleta_model.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends BlocBase {
  final _bloc = HomeBloc();
  Atleta _atleta;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final _userController = BehaviorSubject<Atleta>();
  final _imagemController = BehaviorSubject<String>();
  bool _stateController = false;

  Stream<Atleta> get outUser => _userController.stream;
  Stream<String> get outImagem => _imagemController.stream;

  LoginBloc() {
    _getUser();
  }

    Future<FirebaseUser> _getUser() async {
      _stateController = false;
      // Se for nulo tenta logar e retorna o user
      try {
        final GoogleSignInAccount googleSignInAccount = await googleSignIn
            .signIn();
        //Pega os dados de autenticacao do Google
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount
            .authentication;
        //Passa as credenciais do Google para o AuthCredential do Firebase
        final AuthCredential credential = GoogleAuthProvider.getCredential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);
        //login no Firebase
        final AuthResult authResult = await FirebaseAuth.instance
            .signInWithCredential(credential);
        //Pega o user do Firebase
        final FirebaseUser user = authResult.user;
        Firestore.instance.collection('atletas').document(user.uid)
            .snapshots()
            .listen((event) {
          if (event.data == null) {
            _atleta = Atleta()
              ..uid = user.uid
              ..email = user.email
              ..nome = user.displayName
              ..fotoUrl = user.photoUrl
              ..fone = user.phoneNumber ?? '';

            _bloc.addAtleta(user.uid, _atleta);
            return user;
          } else {
            _atleta = Atleta.fromMap(event);
          }
          _stateController = true;
          _userController.add(_atleta);

        });

      } catch (error) {
        _userController.addError(error);
        _stateController = false;
      }
    }

    void deslogar(){
      googleSignIn.signOut();
    }

    void logar() {
      _getUser();
    }

    Atleta getAtleta(){
      return _atleta;
    }

    bool getLoading(){
      return _stateController;
    }

  Stream<DocumentSnapshot>  getImagem() => Firestore.instance.collection('home').document('foto_home').snapshots();
  
  @override
  void dispose() {
    super.dispose();
    _userController.close();
    _imagemController.close();
  }
}
