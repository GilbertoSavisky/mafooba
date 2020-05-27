
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mafooba/app/shared/base_model.dart';

class Mensagens extends BaseModel {
  String _documentId;

  DateTime horario;
  String imagem;
  String texto;
  String sender;

  Mensagens();

  Mensagens.fromMap(DocumentSnapshot document) {
    _documentId = document.documentID;
    Timestamp timestamp = document.data["horario"];
    this.horario =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    this.imagem = document.data["imagem"];
    this.texto = document.data["texto"];
    this.sender = document.data["sender"];
  }

  @override
  toMap() {
    var map = new Map<String, dynamic>();
    map['horario'] = this.horario;
    map['imagem'] = this.imagem;
    map['texto'] = this.texto;
    map['sender'] = this.sender;

    return map;
  }

  @override
  String documentId() => _documentId;
}
