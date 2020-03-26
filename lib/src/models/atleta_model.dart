
import 'package:cloud_firestore/cloud_firestore.dart';

import '../shared/base_model.dart';

class Atleta extends BaseModel {
  String _documentId;

  String nome;
  bool isGoleiro;
  bool isAtivo;
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
    this.isGoleiro = document.data["isGoleiro"] ?? false;
    this.isAtivo = document.data["isAtivo"] ?? false;
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
    map['isGoleiro'] = this.isGoleiro;
    map['isAtivo'] = this.isAtivo;
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
