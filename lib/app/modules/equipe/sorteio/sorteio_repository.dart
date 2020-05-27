import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mafooba/app/modules/models/atleta_model.dart';
import 'package:mafooba/app/modules/models/sorteio_equipe_model.dart';
import 'package:rxdart/rxdart.dart';

class SorteioRepository extends Disposable {

  CollectionReference _collection = Firestore.instance.collection('equipes');

  void add(String equipeId, Sorteio sorteio) => _collection.document(equipeId).collection('sorteio').document().setData(sorteio.toMap());

  void addAtleta(String documentId, Atleta atleta) =>
      _collection.document(documentId).setData(atleta.toMap());

  void update(String equipeId, String documentId, Sorteio sorteio) =>
      _collection.document(documentId).collection(equipeId).document().updateData(sorteio.toMap());

  void delete(String documentId) => _collection.document(documentId).delete();

  Stream<DocumentSnapshot>  getAtleta(String documentId) => _collection.document(documentId).snapshots();

  Stream<List<Atleta>> getAtletaFiltro (String documentId) {
    return _collection.where('uid', isEqualTo: documentId).snapshots().map((query) {
      return query.documents.map<Atleta>((doc) {
        return  Atleta.fromMap(doc);
      }).toList();
    });
  }


  Observable<List<Atleta>> get atleta =>
      Observable(_collection.snapshots().map((query) => query.documents
          .map<Atleta>((document) => Atleta.fromMap(document))
          .toList()));


  @override
  void dispose() {}
}
