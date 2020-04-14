import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mafooba/src/models/bate_papo_model.dart';
import 'package:mafooba/src/models/mensagens_model.dart';
import 'package:rxdart/rxdart.dart';

class BatePapoRepository extends Disposable {
  CollectionReference _collection = Firestore.instance.collection('bate_papo');

  void addBatePapo(BatePapo batePapo) => _collection.document().setData(batePapo.toMap());
  void addMensagem(Mensagens mensagens) => _collection.document().setData(mensagens.toMap());

  void updateBatePapo(String documentId, BatePapo batePapo) =>
      _collection.document(documentId).updateData(batePapo.toMap());

  void updateMensagem(String documentId, Mensagens mensagem) =>
      _collection.document(documentId).updateData(mensagem.toMap());

  void delete(String documentId) => _collection.document(documentId).delete();

  Stream<DocumentSnapshot>  getBatePapo(String documentoID) => _collection.document(documentoID).snapshots();

  Stream<DocumentSnapshot>  getMensagens(String docID) => _collection.document(docID).snapshots();

  Stream<List<Mensagens>>  getMsg(String docID) =>
      _collection.document(docID).collection('mensagens').orderBy('horario', descending: true).snapshots().map((query) =>
          query.documents.map<Mensagens>((doc) => Mensagens.fromMap(doc)).toList());

  Stream<List<BatePapo>>  filtrarBatePapo({String currentID, String destinatarioID}) =>
      _collection.where('remetenteUID', isEqualTo: currentID).where('destinatarioUID', isEqualTo: destinatarioID).snapshots().map((query) =>
          query.documents.map<BatePapo>((doc) => BatePapo.fromMap(doc)).toList());

  Observable<List<BatePapo>> get batePapo =>
      Observable(_collection.snapshots().map((query) => query.documents
          .map<BatePapo>((document) => BatePapo.fromMap(document))
          .toList()));

  @override
  void dispose() {}
}
