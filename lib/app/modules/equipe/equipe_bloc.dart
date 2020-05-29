import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mafooba/app/app_module.dart';
import 'package:mafooba/app/modules/models/atleta_model.dart';
import 'package:mafooba/app/modules/models/equipe_model.dart';
import 'package:rxdart/rxdart.dart';
import 'equipe_repository.dart';

class EquipeBloc extends BlocBase {
  String _documentId;
  String _nome;
  String _local;
  String _estilo;
  String _info;
  String _imagem;
  bool _ativo;
  DateTime _horario;
  String _fone;
  int _qtdeAtletas;
  int _valor;
  String _tipoSorteio;

  List _capitaoRef;
  List _atletasRef;

  List<Atleta> _capitao;
  List<Atleta> _atletas;

  EquipeBloc() {
    _horarioController.listen((value) => _horario = value);
    _nomeController.listen((value) => _nome = value);
    _localController.listen((value) => _local = value);
    _estiloController.listen((value) => _estilo = value);
    _infoController.listen((value) => _info = value);
    _imagemController.listen((value) => _imagem = value);
    _foneController.listen((value) => _fone = value);
    _qtdeAtletasController.listen((value) => _qtdeAtletas = value);
    _ativoController.listen((value) => _ativo = value);
    _valorController.listen((value) => _valor = value);
    _tipoSorteioController.listen((value) => _tipoSorteio = value);

    _capitaoRefController.listen((value) => _capitaoRef = value);
    _atletasRefController.listen((value) => _atletasRef = value);
    _capitaoController.listen((value) => _capitao = value);
    _atletasController.listen((value) => _atletas = value);
  }

  var _repository = AppModule.to.getDependency<EquipeRepository>();

  void setEquipe(Equipe equipe) {
    _documentId = equipe.documentId();
    setNome(equipe.nome);
    setEstilo(equipe.estilo);
    setLocal(equipe.local);
    setFone(equipe.fone);
    setInfo(equipe.info);
    setValor(equipe.valor);
    setImagem(equipe.imagem);
    setQtdeAtletas(equipe.qtdeAtletas);
    setTipoSorteio(equipe.tipoSorteio);
    setAtivo(equipe.ativo);
    setHorario(equipe.horario);
    setCapitaoRef(equipe.capitaoRef);
    setAtletasRef(equipe.atletasRef);
    setCapitao(equipe.capitao);
    setAtletas(equipe.atletas);
  }

  var _horarioController = BehaviorSubject<DateTime>();
  Stream<DateTime> get outHorario => _horarioController.stream;
  var _nomeController = BehaviorSubject<String>();
  Stream<String> get outNome => _nomeController.stream;
  var _localController = BehaviorSubject<String>();
  Stream<String> get outLocal => _localController.stream;
  var _estiloController = BehaviorSubject<String>();
  Stream<String> get outEstilo => _estiloController.stream;
  var _infoController = BehaviorSubject<String>();
  Stream<String> get outInfo => _infoController.stream;
  var _imagemController = BehaviorSubject<String>();
  Stream<String> get outImagem => _imagemController.stream;
  var _foneController = BehaviorSubject<String>();
  Stream<String> get outFone => _foneController.stream;
  var _qtdeAtletasController = BehaviorSubject<int>();
  Stream<int> get outQtdeAtletas => _qtdeAtletasController.stream;
  var _ativoController = BehaviorSubject<bool>();
  Stream<bool> get outAtivo => _ativoController.stream;

  var _atletasRefController = BehaviorSubject<List>();
  Stream<List> get outAtletasRef => _atletasRefController.stream;
  var _capitaoRefController = BehaviorSubject<List>();
  Stream<List> get outCapitaoRef => _capitaoRefController.stream;

  var _atletasController = BehaviorSubject<List<Atleta>>();
  Stream<List<Atleta>> get outAtletas => _atletasController.stream;
  var _capitaoController = BehaviorSubject<List<Atleta>>();
  Stream<List<Atleta>> get outCapitao => _capitaoController.stream;

  var _valorController = BehaviorSubject<int>();
  Stream<int> get outValor => _valorController.stream;
  var _tipoSorteioController = BehaviorSubject<String>();
  Stream<String> get outTipoSorteio => _tipoSorteioController.stream;
  var _loadingController = BehaviorSubject<bool>();
  Stream<bool> get outLoading => _loadingController.stream;


  void setHorario(DateTime value) => _horarioController.sink.add(value);
  void setAtivo(bool value) => _ativoController.sink.add(value);
  void setNome(String value) => _nomeController.sink.add(value);
  void setLocal(String value) => _localController.sink.add(value);
  void setEstilo(String value) => _estiloController.sink.add(value);
  void setInfo(String value) => _infoController.sink.add(value);
  void setImagem(String value) => _imagemController.sink.add(value);
  void setQtdeAtletas(int value) => _qtdeAtletasController.sink.add(value);
  void setFone(String value) => _foneController.sink.add(value);
  void setValor(int value) => _valorController.sink.add(value);
  void setTipoSorteio(String value) => _tipoSorteioController.sink.add(value);

  void setCapitaoRef(List value) => _capitaoRefController.sink.add(value);
  void setAtletasRef(List value) => _atletasRefController.sink.add(value);
  void setCapitao(List<Atleta> value) => _capitaoController.sink.add(value);
  void setAtletas(List<Atleta> value) => _atletasController.sink.add(value);

  bool insertOrUpdate() {
    var equipe = Equipe()
    ..nome = _nome
    ..local = _local
    ..estilo = _estilo
    ..info = _info
    ..imagem = _imagem
    ..qtdeAtletas = _qtdeAtletas
    ..valor = _valor
    ..fone = _fone
    ..horario = _horario
    ..capitaoRef = _capitaoRef
    ..ativo = _ativo
    ..tipoSorteio = _tipoSorteio
    ..atletasRef = _atletasRef;

    if (_documentId?.isEmpty ?? true) {
      _repository.add(equipe);
    } else {
      _repository.update(_documentId, equipe);
    }

    return true;
  }

  Future<String> trocarImagem(File imgFile) async {
    if (imgFile != null) {
      _loadingController.add(true);
      StorageUploadTask task = FirebaseStorage.instance
          .ref()
          .child('perfilEquipes')
          .child(_nome)
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(imgFile);


      StorageTaskSnapshot taskSnapshot = await task.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();

      setImagem(url);
      _loadingController.add(false);
    }
  }

  void removeAtleta(Atleta atleta) {
    _atletasRef.remove(atleta.referencia.path);
    _atletas.removeWhere((element) => element.documentId() == atleta.documentId());
    setAtletas(_atletas);
    setAtletasRef(_atletasRef);

  }

  void addAtleta(Atleta atleta){
    _atletas.add(atleta);
    _atletasRef.add(atleta.referencia.path);
    setAtletasRef(_atletasRef);
    setAtletas(_atletas);
  }

  @override
  void dispose() {
    _horarioController.close();
    _ativoController.close();
    _nomeController.close();
    _estiloController.close();
    _localController.close();
    _infoController.close();
    _valorController.close();
    _imagemController.close();
    _qtdeAtletasController.close();
    _foneController.close();
    _capitaoRefController.close();
    _atletasRefController.close();
    _capitaoController.close();
    _atletasController.close();
    _tipoSorteioController.close();
    super.dispose();
  }
}
