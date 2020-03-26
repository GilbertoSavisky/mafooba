import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mafooba/src/models/equipe_model.dart';
import 'package:rxdart/rxdart.dart';

class EquipeRepository extends Disposable {
  CollectionReference _collection = Firestore.instance.collection('equipe');

  void add(Equipe equipe) => _collection.add(equipe.toMap());

  void update(String documentId, Equipe equipe) =>
      _collection.document(documentId).updateData(equipe.toMap());

  void delete(String documentId) => _collection.document(documentId).delete();

  Observable<List<Equipe>> get equipe =>
      Observable(_collection.snapshots().map((query) => query.documents
          .map<Equipe>((document) => Equipe.fromMap(document))
          .toList()));

  @override
  void dispose() {}
}
