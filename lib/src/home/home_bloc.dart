import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mafooba/src/atleta/atleta_repository.dart';
import 'package:mafooba/src/chat/chat_repository.dart';
import 'package:mafooba/src/equipe/equipe_repository.dart';
import 'package:mafooba/src/models/atleta_model.dart';
import 'package:rxdart/rxdart.dart';

import '../app_module.dart';

class
HomeBloc extends BlocBase {
  var _repositoryAtleta = AppModule.to.getDependency<AtletaRepository>();
  get atleta => _repositoryAtleta.atleta;

  var _repositoryEquipe = AppModule.to.getDependency<EquipeRepository>();
  get equipe => _repositoryEquipe.equipe;

  var _repositoryChat = AppModule.to.getDependency<ChatRepository>();
  get chat => _repositoryChat.chat;

  void deleteAtleta(String documentId) => _repositoryAtleta.delete(documentId);
  void addAtleta(String docID, Atleta atleta) => _repositoryAtleta.addAtleta(docID, atleta);
  void deleteEquipe(String documentId) => _repositoryEquipe.delete(documentId);
  void deleteChat(String documentId) => _repositoryChat.delete(documentId);

  @override
  void dispose() {
    super.dispose();
  }

  Stream<DocumentSnapshot> getData(String uid) => _repositoryAtleta.getData(uid);
}
