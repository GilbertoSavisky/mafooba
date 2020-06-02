import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mafooba/app/modules/models/atleta_model.dart';
import 'package:mafooba/app/modules/models/partida_model.dart';
import 'package:rxdart/rxdart.dart';

class PartidaRepository extends Disposable {

  CollectionReference _collection = Firestore.instance.collection('equipes');

  void add(String equipeId, Partida partida) => _collection.document(equipeId).collection('partidas').document().setData(partida.toMap());

  void addAtleta(String documentId, Atleta atleta) =>
      _collection.document(documentId).setData(atleta.toMap());

  void update(String equipeId, String documentId, Partida partida) =>
      _collection.document(documentId).collection(equipeId).document().updateData(partida.toMap());

  void delete(String documentId) => _collection.document(documentId).delete();

  Stream<DocumentSnapshot>  getAtleta(String documentId) => _collection.document(documentId).snapshots();

  Observable<List<Partida>> sorteio(String equipeId) =>
      Observable(_collection.document(equipeId).collection('partidas').snapshots().map((query) => query.documents
          .map<Partida>((document) => Partida.fromMap(document))
          .toList()));


  @override
  void dispose() {}
}
