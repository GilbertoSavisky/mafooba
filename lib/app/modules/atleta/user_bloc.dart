import 'dart:io';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mafooba/app/modules/atleta/atleta_repository.dart';
import 'package:mafooba/app/modules/home/home_bloc.dart';
import 'package:mafooba/app/modules/models/atleta_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../app_module.dart';

class UserBloc extends BlocBase {

  final _userController = BehaviorSubject<List>();
  Map<String, Map<String, dynamic>> _users = {};
  Firestore _firestore = Firestore.instance;

  Stream<List> get outUsers =>  _userController.stream;

  UserBloc() {
    _addUsersListener();
  }

  void _addUsersListener(){
    _firestore.collection('atletas').snapshots().listen((atleta) {
      atleta.documentChanges.forEach((element) {
        print('.....1111...${element.document.data}');
        String uid = element.document.documentID;
        switch(element.type){
          case DocumentChangeType.added:
            _users['uid'] = element.document.data;
            break;
          case DocumentChangeType.modified:
            _users['uid'].addAll(element.document.data);
            break;
          case DocumentChangeType.removed:
            _users.remove(uid);
            break;
        }
      });
      _userController.add(_users.values.toList());
    });
  }


  void buscaAtleta(String texto){

  }
  @override
  void dispose() {
    _userController.close();
    super.dispose();
  }
}