import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mafooba/src/models/chat_model.dart';
import 'package:rxdart/rxdart.dart';

class ChatRepository extends Disposable {
  CollectionReference _collection = Firestore.instance.collection('mensagens');

  void add(Chat chat) => _collection.add(chat.toMap());

  void update(String documentId, Chat chat) =>
      _collection.document(documentId).updateData(chat.toMap());

  void delete(String documentId) => _collection.document(documentId).delete();

  Observable<List<Chat>> get chat =>
      Observable(_collection.snapshots().map((query) => query.documents
          .map<Chat>((document) => Chat.fromMap(document))
          .toList()));

  @override
  void dispose() {}
}
