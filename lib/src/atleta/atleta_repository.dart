import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mafooba/src/models/atleta_model.dart';
import 'package:rxdart/rxdart.dart';

class AtletaRepository extends Disposable {
  CollectionReference _collection = Firestore.instance.collection('atletas');

  void add(Atleta atleta) => _collection.add(atleta.toMap());

  void update(String documentId, Atleta equipe) =>
      _collection.document(documentId).updateData(equipe.toMap());

  void delete(String documentId) => _collection.document(documentId).delete();

  Observable<List<Atleta>> get atleta =>
      Observable(_collection.snapshots().map((query) => query.documents
          .map<Atleta>((document) => Atleta.fromMap(document))
          .toList()));

  @override
  void dispose() {}
}
