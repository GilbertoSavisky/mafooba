import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mafooba/app/modules/home/home_bloc.dart';
import 'package:mafooba/app/modules/models/atleta_model.dart';
import 'package:rxdart/rxdart.dart';

class AtletaRepository extends Disposable {

  CollectionReference _collection = Firestore.instance.collection('atletas');

  void add(Atleta atleta) => _collection.document(atleta.uid).setData(atleta.toMap());

  void addAtleta(String documentId, Atleta atleta) =>
      _collection.document(documentId).setData(atleta.toMap());

  void update(String documentId, Atleta atleta) =>
      _collection.document(documentId).updateData(atleta.toMap());

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
