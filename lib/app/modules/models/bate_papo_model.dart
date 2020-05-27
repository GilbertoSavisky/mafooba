import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mafooba/app/shared/base_model.dart';

class BatePapo extends BaseModel {
  String _documentId;

  String destinatario;
  String remetente;
  bool visualizado;

  BatePapo();

  BatePapo.fromMap(DocumentSnapshot document) {
    _documentId = document.documentID;

    this.destinatario = document.data["destinatario"];
    this.remetente = document.data["remetente"];
    this.visualizado = document.data['visualizado'];

  }

  @override
  toMap() {
    var map = new Map<String, dynamic>();
    map['destinatario'] = this.destinatario;
    map['remetente'] = this.remetente;
    map['visualizado'] = this.visualizado;

    return map;
  }

  @override
  String documentId() => _documentId;
}
