import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String _foneContato;
  int _qtdeAtletas;
  int _valor;
  String _tipoSorteio;
  String _temposPartida;
  String _duracaoPartida;
  String _tipoPagamento;
  String _sortearPor;
  String _horaSorteio;

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
    _foneContatoController.listen((value) => _foneContato = value);
    _qtdeAtletasController.listen((value) => _qtdeAtletas = value);
    _ativoController.listen((value) => _ativo = value);
    _valorController.listen((value) => _valor = value);
    _tipoSorteioController.listen((value) => _tipoSorteio = value);
    _temposPartidaController.listen((value) => _temposPartida = value);
    _duracaoPartidaController.listen((value) => _duracaoPartida = value);
    _tipoPagamentoController.listen((value) => _tipoPagamento = value);
    _sortearPorController.listen((value) => _sortearPor = value);
    _horaSorteioController.listen((value) => _horaSorteio = value);

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
    setFoneContato(equipe.foneContato);
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
    setTemposPartida(equipe.temposPartida);
    setDuracaoPartida(equipe.duracaoPartida);
    setTipoPagamento(equipe.tipoPagamento);
    setSortearPor(equipe.sortearPor);
    setHoraSorteio(equipe.horaSorteio);
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
  var _foneContatoController = BehaviorSubject<String>();
  Stream<String> get outFoneContato => _foneContatoController.stream;
  var _qtdeAtletasController = BehaviorSubject<int>();
  Stream<int> get outQtdeAtletas => _qtdeAtletasController.stream;
  var _ativoController = BehaviorSubject<bool>();
  Stream<bool> get outAtivo => _ativoController.stream;
  var _temposPartidaController = BehaviorSubject<String>();
  Stream<String> get outTemposPartida => _temposPartidaController.stream;
  var _duracaoPartidaController = BehaviorSubject<String>();
  Stream<String> get outDuracaoPartida => _duracaoPartidaController.stream;
  var _tipoPagamentoController = BehaviorSubject<String>();
  Stream<String> get outTipoPagamento => _tipoPagamentoController.stream;
  var _sortearPorController = BehaviorSubject<String>();
  Stream<String> get outSortearPor => _sortearPorController.stream;
  var _horaSorteioController = BehaviorSubject<String>();
  Stream<String> get outHoraSorteio => _horaSorteioController.stream;

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
  void setFoneContato(String value) => _foneContatoController.sink.add(value);
  void setValor(int value) => _valorController.sink.add(value);
  void setTipoSorteio(String value) => _tipoSorteioController.sink.add(value);
  void setTemposPartida(String value) => _temposPartidaController.sink.add(value);
  void setDuracaoPartida(String value) => _duracaoPartidaController.sink.add(value);
  void setTipoPagamento(String value) => _tipoPagamentoController.sink.add(value);
  void setSortearPor(String value) => _sortearPorController.sink.add(value);
  void setHoraSorteio(String value) => _horaSorteioController.sink.add(value);

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
    ..foneContato = _foneContato
    ..horario = _horario
    ..capitaoRef = _capitaoRef
    ..ativo = _ativo
    ..tipoSorteio = _tipoSorteio
    ..temposPartida = _temposPartida
    ..duracaoPartida = _duracaoPartida
    ..tipoPagamento = _tipoPagamento
    ..sortearPor = _sortearPor
    ..horaSorteio = _horaSorteio
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

  Stream<DocumentSnapshot>  getImagem() => Firestore.instance.collection('home').document('imgFundo').snapshots();

  void removeAtleta(Atleta atleta) {
    _atletasRef.remove(atleta.referencia);
    _atletas.removeWhere((element) => element.documentId() == atleta.documentId());
    setAtletas(_atletas);
    setAtletasRef(_atletasRef);

  }

  void addAtleta(Atleta atleta){
    _atletas.add(atleta);
    _atletasRef.add(atleta.referencia);
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
    _foneContatoController.close();
    _capitaoRefController.close();
    _atletasRefController.close();
    _capitaoController.close();
    _atletasController.close();
    _tipoSorteioController.close();
    _temposPartidaController.close();
    _duracaoPartidaController.close();
    _tipoPagamentoController.close();
    _sortearPorController.close();
    _horaSorteioController.close();
    super.dispose();
  }
}
