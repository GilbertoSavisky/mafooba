import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mafooba/src/models/atleta_model.dart';

import '../shared/base_model.dart';

class Equipe extends BaseModel {
  String _documentId;
  String nomeEquipe;
  String local;
  String estilo;
  String info;
  int totalJogadores;
  Atleta capitao;
  List<Atleta> jogadores;
  String foneCampo;
  bool active;
  DateTime horario;

  Equipe();

  Equipe.fromMap(DocumentSnapshot document) {
    _documentId = document.documentID;

    this.nomeEquipe = document.data["nomeEquipe"];
    this.capitao = document.data["capitao"];
    this.estilo = document.data["estilo"];
    this.local = document.data["local"];
    this.foneCampo = document.data["foneCampo"];
    this.info = document.data["info"];
    this.jogadores = document.data["jogadores"];
    this.totalJogadores = document.data["totalJogadores"];
    this.active = document.data["active"] ?? false;
    Timestamp timestamp = document.data["horario"];
    this.horario =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  }

  @override
  toMap() {
    var map = new Map<String, dynamic>();
    map['nomeEquipe'] = this.nomeEquipe;
    map['estilo'] = this.estilo;
    map['local'] = this.local;
    map['jogadores'] = this.jogadores;
    map['info'] = this.info;
    map['totalJogadores'] = this.totalJogadores;
    map['foneCampo'] = this.foneCampo;
    map['capitao'] = this.capitao;
    map['active'] = this.active;
    map['horario'] = this.horario;
    return map;
  }

  @override
  String documentId() => _documentId;
}
