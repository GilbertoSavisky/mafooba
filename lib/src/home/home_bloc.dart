import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mafooba/src/atleta/atleta_repository.dart';
import 'package:mafooba/src/bate_papo/bate_papo_repository.dart';
import 'package:mafooba/src/equipe/equipe_repository.dart';
import 'package:mafooba/src/models/atleta_model.dart';
import 'package:mafooba/src/models/bate_papo_model.dart';
import 'package:mafooba/src/models/mensagens_model.dart';

import '../app_module.dart';

class
HomeBloc extends BlocBase {
  var _repositoryAtleta = AppModule.to.getDependency<AtletaRepository>();
  get atleta => _repositoryAtleta.atleta;

  var _repositoryEquipe = AppModule.to.getDependency<EquipeRepository>();
  get equipe => _repositoryEquipe.equipe;

  var _repositoryBatePapo = AppModule.to.getDependency<BatePapoRepository>();
  get batePapo => _repositoryBatePapo.batePapo;

  var _repositoryMsg = AppModule.to.getDependency<BatePapoRepository>();
  getMsg(String docID, bool ordenar) => _repositoryMsg.getMsg(docID, ordenar);

  filtrarBatePapo({String currentID, String destinatarioID}) => _repositoryBatePapo.filtrarBatePapo(currentID: currentID, destinatarioID: destinatarioID);

  void deleteAtleta(String documentId) => _repositoryAtleta.delete(documentId);
  void addAtleta(String docID, Atleta atleta) => _repositoryAtleta.addAtleta(docID, atleta);
  void addBatePapo(BatePapo batePapo) => _repositoryBatePapo.addBatePapo(batePapo);
  void deleteEquipe(String documentId) => _repositoryEquipe.delete(documentId);
  void deleteChat(String documentId) => _repositoryBatePapo.delete(documentId);
  void updateChat(String documentId, BatePapo batePapo) => _repositoryBatePapo.updateBatePapo(documentId, batePapo);
  void updateMensagem(String documentId, Mensagens mensagem) => _repositoryBatePapo.updateMensagem(documentId, mensagem);

  @override
  void dispose() {
    super.dispose();
  }

  Stream<DocumentSnapshot> getAtleta(String documentId) => _repositoryAtleta.getAtleta(documentId);
  Stream<DocumentSnapshot> getBatePapo(String documentId) => _repositoryBatePapo.getBatePapo(documentId);
  //Observable<List<Mensagens>> getMsg(String docID) => _repositoryChat.getMsg(docID);
}
