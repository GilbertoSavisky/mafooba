
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mafooba/app/shared/base_model.dart';

class Sorteio extends BaseModel {
  String _documentId;
  String equipeId;

  String timeA;
  String timeB;
  DateTime dthr_sorteio;

  Sorteio();

  Sorteio.fromMap(DocumentSnapshot document) {
    _documentId =  document.data['uid'];//document.documentID;
    this.timeA = document.data["timeA"];
    this.timeB = document.data["timeB"];
    Timestamp timestamp = document.data["dthr_sorteio"];
    this.dthr_sorteio =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  }

  @override
  toMap() {
    var map = new Map<String, dynamic>();
    map['timeA'] = this.timeA;
    map['timeB'] = this.timeB;
    map['dthr_sorteio'] = this.dthr_sorteio;

    return map;
  }

  @override
  String documentId() => _documentId;
}
