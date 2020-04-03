
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

  Atleta();

  Atleta.fromMap(DocumentSnapshot document) {
    _documentId = document.documentID;

    this.nome = document.data["nome"];
    this.nickName = document.data["nickName"];
    this.isGoleiro = document.data["isGoleiro"] ?? false;
    this.isAtivo = document.data["isAtivo"] ?? false;
    this.selecionado = document.data["selecionado"] ?? false;
    this.faltas = document.data["faltas"];
    this.posicao = document.data["posicao"];
    this.email = document.data["email"];
    this.fone = document.data["fone"];
    this.fotoUrl = document.data["fotoUrl"];
    this.uid = document.data["uid"];
    this.habilidade = document.data["habilidade"];
  }
  @override
  toMap() {
    var map = new Map<String, dynamic>();
    map['nome'] = this.nome;
    map['nickName'] = this.nickName;
    map['isGoleiro'] = this.isGoleiro;
    map['isAtivo'] = this.isAtivo;
    map['selecionado'] = this.selecionado;
    map['faltas'] = this.faltas;
    map['posicao'] = this.posicao;
    map['email'] = this.email;
    map['fone'] = this.fone;
    map['fotoUrl'] = this.fotoUrl;
    map['uid'] = this.uid;
    map['habilidade'] = this.habilidade;
//    print(map);
    return map;
  }

  @override
  String documentId() => _documentId;
}
