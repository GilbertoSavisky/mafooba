
import 'package:cloud_firestore/cloud_firestore.dart';

import '../shared/base_model.dart';

class BatePapo extends BaseModel {
  String _documentId;

  String destinatarioUID;
  String remetenteUID;

  BatePapo();

  BatePapo.fromMap(DocumentSnapshot document) {
    _documentId = document.documentID;

    this.destinatarioUID = document.data["destinatarioUID"];
    this.remetenteUID = document.data["remetenteUID"];
    //print('*********************${document.data}');
  }

  @override
  toMap() {
    var map = new Map<String, dynamic>();
    map['destinatarioUID'] = this.destinatarioUID;
    map['remetenteUID'] = this.remetenteUID;
    return map;
  }

  @override
  String documentId() => _documentId;
}
