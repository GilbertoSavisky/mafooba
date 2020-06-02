
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mafooba/app/shared/base_model.dart';

class Partida extends BaseModel {
  String _documentId;
  String equipeId;

  List timeA;
  List timeB;
  DateTime dthrSorteio;
  List confirmados;

  Partida();

  Partida.fromMap(DocumentSnapshot document) {

    _documentId =  document.data['uid'];//document.documentID;
    this.timeA = document.data["timeA"];
    this.timeB = document.data["timeB"];
    this.confirmados = document.data['confirmados'];
    Timestamp timestamp = document.data["dthrSorteio"];
    this.dthrSorteio =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  }

  @override
  toMap() {
    var map = new Map<String, dynamic>();
    map['timeA'] = this.timeA;
    map['timeB'] = this.timeB;
    map['dthrSorteio'] = this.dthrSorteio;
    map['confirmados'] = this.confirmados;

    return map;
  }

  @override
  String documentId() => _documentId;
}
