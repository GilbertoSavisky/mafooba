import 'dart:async';

import 'package:async/async.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mafooba/src/home/home_bloc.dart';
import 'package:mafooba/src/models/atleta_model.dart';
import 'package:mafooba/src/models/bate_papo_model.dart';
import 'package:mafooba/src/models/mensagens_model.dart';
import 'package:rxdart/rxdart.dart';

class BatePapoRepository extends Disposable {

  CollectionReference _collection = Firestore.instance.collection('bate_papo');

  void addBatePapo(BatePapo batePapo) => _collection.document().setData(batePapo.toMap());

  void updateBatePapo(String documentId, BatePapo batePapo) =>
      _collection.document(documentId).updateData(batePapo.toMap());

  void updateMensagem(String documentId, Mensagens mensagem) =>
      _collection.document(documentId).collection('mensagens').document().setData(mensagem.toMap());

  void addMensagem(Mensagens mensagem) =>
      _collection.document().collection('mensagens').document().setData(mensagem.toMap());


  void delete(String documentId) => _collection.document(documentId).delete();

  Stream<DocumentSnapshot>  getBatePapo(String documentoID) => _collection.document(documentoID). snapshots();

  Stream<List<Mensagens>>  getMensagens(String documentID) {
    return _collection.document(documentID).collection('mensagens').orderBy('horario', descending: true).snapshots().map((query) {
      return query.documents.map<Mensagens>((doc) => Mensagens.fromMap(doc)).toList();
    });
  }

  Stream<List<BatePapo>>  filtrarCurrenteUserRemetente(String currentID) =>
      _collection.where('remetente', isEqualTo: currentID).snapshots().map((query) =>
          query.documents.map<BatePapo>((doc) => BatePapo.fromMap(doc)).toList());

  Stream<List<BatePapo>>  filtrarCurrenteUserDestinatario(String currentID) =>
      _collection.where('destinatario', isEqualTo: currentID).snapshots().map((query) =>
          query.documents.map<BatePapo>((doc) => BatePapo.fromMap(doc)).toList());

  Observable<List<BatePapo>> get batePapo =>
      Observable(_collection.snapshots().map((query) => query.documents
          .map<BatePapo>((document) => BatePapo.fromMap(document))
          .toList()));

  @override
  void dispose() {}
}
