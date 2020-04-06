
import 'package:cloud_firestore/cloud_firestore.dart';

import '../shared/base_model.dart';

class Chat extends BaseModel {
  String _documentId;

  String fotoUrl;
  DateTime horario;
  String nickName;
  String ultimaMsg;
  bool visualizado;

  Chat();

  Chat.fromMap(DocumentSnapshot document) {
    _documentId = document.documentID;
    this.fotoUrl = document.data["fotoUrl"];
    Timestamp timestamp = document.data["horario"];
    this.horario =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    this.nickName = document.data["nickName"];
    this.ultimaMsg = document.data["ultimaMsg"];
    this.visualizado = document.data["visualizado"] ?? false;


  }

  @override
  toMap() {
    var map = new Map<String, dynamic>();
    map['fotoUrl'] = this.fotoUrl;
    map['horario'] = DateTime.now();
    map['nickName'] = this.nickName;
    map['ultimaMsg'] = this.ultimaMsg;
    map['visualizado'] = this.visualizado;

    return map;
  }

  @override
  String documentId() => _documentId;
}
