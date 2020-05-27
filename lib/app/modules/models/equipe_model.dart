import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mafooba/app/modules/models/atleta_model.dart';
import 'package:mafooba/app/shared/base_model.dart';

class Equipe extends BaseModel {
  String _documentId;
  String nome;
  String local;
  String estilo;
  String info;
  String imagem;
  int qtdeAtletas;
  String fone;
  DateTime horario;
  bool ativo;
  int valor;
  String tipoSorteio;

  List capitaoRef;
  List atletasRef;

  List<Atleta> capitao = [];
  List<Atleta> atletas = [];

  Equipe();

  Equipe.fromMap(DocumentSnapshot document) {
    _documentId = document.documentID;
    this.nome = document.data["nome"];
    this.estilo = document.data["estilo"];
    this.local = document.data["local"];
    this.fone = document.data["fone"];
    this.info = document.data["info"];
    print('............................................${document.data}');
    this.valor = (document.data["valor"]);
    this.imagem = document.data["imagem"];
    this.qtdeAtletas = document.data["qtdeAtletas"];
    this.ativo = document.data["ativo"] ?? false;
    this.capitaoRef = document.data["capitaoRef"];
    this.atletasRef = document.data["atletasRef"];
    this.tipoSorteio = document.data["tipoSorteio"];

    Timestamp timestamp = document.data["horario"];
    this.horario =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);

    document.data['capitaoRef'].forEach((capp){
      capp.snapshots().listen((cap)async {
        await capitao.add(Atleta.fromMap(cap));
      });
    });

    document.data['atletasRef'].forEach((att) {
      att.snapshots().listen((atl) async {
        await atletas.add(Atleta.fromMap(atl));
      });
    });

  }

  @override
  toMap() {
    var map = new Map<String, dynamic>();
    map['nome'] = this.nome;
    map['estilo'] = this.estilo;
    map['local'] = this.local;
    map['info'] = this.info;
    map['valor'] = this.valor;
    map['imagem'] = this.imagem;
    map['qtdeAtletas'] = this.qtdeAtletas;
    map['fone'] = this.fone;
    map['capitaoRef'] = this.capitaoRef;
    map['atletasRef'] = this.atletasRef;
    map['ativo'] = this.ativo;
    map['horario'] = this.horario;
    map['tipoSorteio'] = this.tipoSorteio;
    return map;
  }

  @override
  String documentId() => _documentId;
}
