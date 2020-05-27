import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mafooba/app/modules/atleta/atleta_repository.dart';
import 'package:mafooba/app/modules/models/atleta_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../app_module.dart';

class AtletaBloc extends BlocBase {
  String _documentId;

  String _nome;
  String _nickName;
  String _fotoUrl;
  bool _isAtivo;
  bool _selecionado;
  int _faltas;
  String _posicao;
  String _email;
  String _fone;
  String _habilidade;
  String _uid;
  String _info;

  AtletaBloc() {
    _nomeController.listen((value) => _nome = value);
    _nickNameController.listen((value) => _nickName = value);
    _fotoUrlController.listen((value) => _fotoUrl = value);
    _isAtivoController.listen((value) => _isAtivo = value);
    _selecionadoController.listen((value) => _selecionado = value);
    _faltasController.listen((value) => _faltas = value);
    _posicaoController.listen((value) => _posicao = value);
    _emailController.listen((value) => _email = value);
    _foneController.listen((value) => _fone = value);
    _habilidadeController.listen((value) => _habilidade = value);
    _uidController.listen((value) => _uid = value);
    _infoController.listen((value) => _info = value);
  }

  var _repository = AppModule.to.getDependency<AtletaRepository>();

  void setAtleta(Atleta atleta) {
    _documentId = atleta.uid; //atleta.documentId();
    setNome(atleta.nome);
    setNickName(atleta.nickName);
    setFotoUrl(atleta.fotoUrl);
    setPosicao(atleta.posicao);
    setIsAtivo(atleta.isAtivo);
    setSelecionado(atleta.selecionado);
    setFaltas(atleta.faltas);
    setEmail(atleta.email);
    setFone(atleta.fone);
    setUid(atleta.uid);
    setInfo(atleta.info);
    setHabilidade(atleta.habilidade);
  }

  var _nomeController = BehaviorSubject<String>();
  Stream<String> get outNome => _nomeController.stream;
  var _nickNameController = BehaviorSubject<String>();
  Stream<String> get outNickName => _nickNameController.stream;
  var _fotoUrlController = BehaviorSubject<String>();
  Stream<String> get outFotoUrl => _fotoUrlController.stream;
  var _isAtivoController = BehaviorSubject<bool>();
  Stream<bool> get outSelecionado => _selecionadoController.stream;
  var _selecionadoController = BehaviorSubject<bool>();
  Stream<bool> get outIsAtivo => _isAtivoController.stream;
  var _faltasController = BehaviorSubject<int>();
  Stream<int> get outFaltas => _faltasController.stream;
  var _posicaoController = BehaviorSubject<String>();
  Stream<String> get outPosicao => _posicaoController.stream;
  var _foneController = BehaviorSubject<String>();
  Stream<String> get outFone => _foneController.stream;
  var _emailController = BehaviorSubject<String>();
  Stream<String> get outEmail => _emailController.stream;

  var _loadingController = BehaviorSubject<bool>();
  Stream<bool> get outLoading => _loadingController.stream;

  var _habilidadeController = BehaviorSubject<String>();
  Stream<String> get outHabilidade => _habilidadeController.stream;

  var _uidController = BehaviorSubject<String>();
  Stream<String> get outUid => _uidController.stream;
  var _infoController = BehaviorSubject<String>();
  Stream<String> get outInfo => _infoController.stream;


  void setNome(String value) => _nomeController.sink.add(value);
  void setNickName(String value) => _nickNameController.sink.add(value);
  void setFotoUrl(String value) => _fotoUrlController.sink.add(value);
  void setIsAtivo(bool value) => _isAtivoController.sink.add(value);
  void setSelecionado(bool value) => _selecionadoController.sink.add(value);
  void setFaltas(int value) => _faltasController.sink.add(value);
  void setPosicao(String value) => _posicaoController.sink.add(value);
  void setFone(String value) => _foneController.sink.add(value);
  void setEmail(String value) => _emailController.sink.add(value);
  void setHabilidade(String value) => _habilidadeController.sink.add(value);
  void setUid(String value) => _uidController.sink.add(value);
  void setInfo(String value) => _infoController.sink.add(value);


  Future<String> trocarImagem(File imgFile) async {
    if (imgFile != null) {
      _loadingController.add(true);
      StorageUploadTask task = FirebaseStorage.instance
          .ref()
          .child('perfilAtletas')
          .child(_nome)
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(imgFile);


      StorageTaskSnapshot taskSnapshot = await task.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();

      setFotoUrl(url);
      _loadingController.add(false);
    }
  }

  bool insertOrUpdate() {
    var atleta = Atleta()

      ..nome = _nome
      ..nickName = _nickName
      ..isAtivo =_isAtivo
      ..selecionado =_selecionado
      ..faltas = _faltas
      ..posicao = _posicao
      ..email = _email
      ..fone = _fone
      ..fotoUrl = _fotoUrl
      ..habilidade = _habilidade
      ..uid = _uid
      ..info = _info;

    if (_documentId?.isEmpty ?? true) {
      _repository.add(atleta);
    } else {
      _repository.update(_documentId, atleta);
    }

    return true;
  }

  @override
  void dispose() {
    _nomeController.close();
    _nickNameController.close();
    _fotoUrlController.close();
    _isAtivoController.close();
    _faltasController.close();
    _posicaoController.close();
    _emailController.close();
    _foneController.close();
    _habilidadeController.close();
    _uidController.close();
    _infoController.close();
    _selecionadoController.close();
    super.dispose();
  }
}