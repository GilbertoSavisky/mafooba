import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mafooba/src/atleta/atleta_bloc.dart';
import 'package:mafooba/src/models/atleta_model.dart';

import '../shared/base_model.dart';

class Equipe extends BaseModel {
  String _documentId;
  String nomeEquipe;
  String local;
  String estilo;
  String info;
  String imagem;
  int totalJogadores;
  double vlrCancha;
  Atleta capitao;
  List<Atleta> listaAtletas;
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
    this.vlrCancha = document.data["vlrCancha"];
    this.imagem = document.data["imagem"];
    this.totalJogadores = document.data["totalJogadores"];
    this.active = document.data["active"] ?? false;
    //this.listaAtletas = document.data["listaAtletas"];
    Timestamp timestamp = document.data["horario"];
    this.horario =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);

    Atleta atleta = new Atleta();
    document.data['atletas'].forEach((f){
      Stream<DocumentSnapshot> doc = Firestore.instance.collection('atleta').document(f.documentID).snapshots();
      doc.forEach((a){
        atleta.uid = a.data['uid'];
        atleta.nome = a.data['nome'];
        atleta.fotoUrl = a.data['fotoUrl'];
        atleta.fone = a.data['fone'];
        atleta.selecionado = a.data['selecionado'];
        atleta.isGoleiro = a.data['isGoleiro'];
        atleta.isAtivo = a.data['isAtivo'];
        atleta.habilidade = a.data['habilidade'];
        atleta.email = a.data['email'];
        atleta.posicao = a.data['posicao'];
        atleta.faltas = a.data['faltas'];

//        this.listaAtletas.insert(0, atleta);

      });
      print('atasa = ${atleta.nome}');
    });

  }

  @override
  toMap() {
    var map = new Map<String, dynamic>();
    map['nomeEquipe'] = this.nomeEquipe;
    map['estilo'] = this.estilo;
    map['local'] = this.local;
    map['listaAtletas'] = this.listaAtletas;
    map['info'] = this.info;
    map['vlrCancha'] = this.vlrCancha;
    map['imagem'] = this.imagem;
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
