
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mafooba/src/models/atleta_model.dart';
import 'package:rxdart/src/observables/observable.dart';

import '../shared/base_model.dart';

class BatePapo extends BaseModel {
  String _documentId;

  String destinatario;
  String remetente;
  bool visualizado;

  DateTime horario;
  String texto;
  String sender;
  String imagem;

  String nickName;
  String nome;
  String fotoUrl;


  BatePapo();

  BatePapo.fromMap(DocumentSnapshot document) {
    _documentId = document.documentID;

    this.destinatario = document.data["destinatario"];
    this.remetente = document.data["remetente"];
    this.visualizado = document.data['visualizado'];
 //   Timestamp timestamp = document.data["horario"];
//    this.horario =
//        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
//    this.texto = document.data["texto"];
//    this.visualizado = document.data["visualizado"] ?? false;
//    this.fotoUrl = document.data["fotoUrl"];
//    this.nome = document.data["nome"];
//    this.nickName = document.data["nickName"];


  }
  BatePapo.fromBatePapo(BatePapo batePapo) {
    //print('from  ${batePapo.toMap()}');
    _documentId = batePapo.documentId();

    this.destinatario = batePapo.destinatario;
    this.remetente = batePapo.remetente;
    this.visualizado = batePapo.visualizado;

    this.texto = batePapo.texto;
    this.sender = batePapo.sender;
    this.imagem = batePapo.imagem;
    this.horario = batePapo.horario;

    this.nome = batePapo.nome;
    this.nickName = batePapo.nickName;
    this.fotoUrl = batePapo.fotoUrl;

  }

  @override
  toMap() {
    var map = new Map<String, dynamic>();
    map['destinatario'] = this.destinatario;
    map['remetente'] = this.remetente;
    map['visualizado'] = this.visualizado;

    map['horario'] = this.horario;
    map['texto'] = this.texto;
    map['sender'] = this.sender;
    map['imagem'] = this.imagem;

    map['nome'] = this.nome;
    map['nickName'] = this.nickName;
    map['fotoUrl'] = this.fotoUrl;


    return map;
  }

  @override
  String documentId() => _documentId;
}
