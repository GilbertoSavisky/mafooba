
import 'package:cloud_firestore/cloud_firestore.dart';

import '../shared/base_model.dart';

class Chat extends BaseModel {
  String _documentId;

  String ultimaMsg;
  String nickName;
  String fotoUrl;
  bool visualizado;
  DateTime horario;
  String uid;

  Chat();

  Chat.fromMap(DocumentSnapshot document) {
    _documentId = document.documentID;

    this.ultimaMsg = document.data["ultimaMsg"];
    this.nickName = document.data["nickName"];
    this.fotoUrl = document.data["fotoUrl"];
    this.uid = document.data["uid"];
    this.visualizado = document.data["visualizado"] ?? false;
    Timestamp timestamp = document.data["horario"];
    this.horario =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  }

  @override
  toMap() {
    var map = new Map<String, dynamic>();
    map['ultimaMsg'] = this.ultimaMsg;
    map['nickName'] = this.nickName;
    map['fotoUrl'] = this.fotoUrl;
    map['uid'] = this.uid;
    map['visualizado'] = this.visualizado;
    map['horario'] = this.horario;
    return map;
  }

  @override
  String documentId() => _documentId;
}
