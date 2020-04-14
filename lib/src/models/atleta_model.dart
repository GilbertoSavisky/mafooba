
import 'package:cloud_firestore/cloud_firestore.dart';

import '../shared/base_model.dart';

class Atleta extends BaseModel {
  String _documentId;

  String nome;
  String nickName;
  bool isGoleiro;
  bool isAtivo;
  bool selecionado;
  int faltas;
  String posicao;
  String email;
  String fone;
  String fotoUrl;
  String uid;
  String habilidade;
  DocumentReference grupoUID;

  Atleta();

  Atleta.fromMap(DocumentSnapshot document) {
    _documentId =  document.data['uid'];//document.documentID;
    this.nome = document.data["nome"];
    this.nickName = document.data["nickName"];
    this.isGoleiro = document.data["isGoleiro"] ?? false;
    this.isAtivo = document.data["isAtivo"] ?? true;
    this.selecionado = document.data["selecionado"] ?? false;
    this.faltas = document.data["faltas"];
    this.posicao = document.data["posicao"];
    this.email = document.data["email"];
    this.fone = document.data["fone"];
    this.fotoUrl = document.data["fotoUrl"];
    this.habilidade = document.data["habilidade"];
    this.uid = document.data['uid'];
    //this.grupoUID = document.data['grupoUID'];

  }
  @override
  toMap() {
    var map = new Map<String, dynamic>();
    map['nome'] = this.nome;
    map['nickName'] = this.nickName ?? '';
    map['isGoleiro'] = this.isGoleiro ?? false;
    map['isAtivo'] = this.isAtivo ?? true;
    map['selecionado'] = this.selecionado ?? false;
    map['faltas'] = this.faltas ?? 0;
    map['posicao'] = this.posicao ?? '';
    map['email'] = this.email;
    map['fone'] = this.fone;
    map['fotoUrl'] = this.fotoUrl;
    map['uid'] = this.uid;
    map['habilidade'] = this.habilidade ?? '';
    map['grupoUID'] = this.grupoUID ?? '';

    return map;
  }

  @override
  String documentId() => _documentId;
}
