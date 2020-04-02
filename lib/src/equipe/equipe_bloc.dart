import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mafooba/src/models/atleta_model.dart';
import 'package:mafooba/src/models/equipe_model.dart';
import 'package:rxdart/rxdart.dart';
import '../app_module.dart';
import 'equipe_repository.dart';

class EquipeBloc extends BlocBase {
  String _nomeEquipe;
  String _local;
  String _estilo;
  String _info;
  String _imagem;
  int _totalJogadores;
  double _vlrCancha;
  Atleta _capitao;
  List<Atleta> _listaAtletas;
  String _foneCampo;
  DateTime _horario;
  bool _active;
  String _documentId;

  EquipeBloc() {
    _horarioController.listen((value) => _horario = value);
    _nomeEquipeController.listen((value) => _nomeEquipe = value);
    _localController.listen((value) => _local = value);
    _estiloController.listen((value) => _estilo = value);
    _infoController.listen((value) => _info = value);
    _vlrCanchaController.listen((value) => _vlrCancha = value);
    _imagemController.listen((value) => _imagem = value);
    _foneCampoController.listen((value) => _foneCampo = value);
    _capitaoController.listen((value) => _capitao = value);
    _totalJogadoresController.listen((value) => _totalJogadores = value as int);
    _activeController.listen((value) => _active = value);

    _listaAtletasController.listen((value) => _listaAtletas = value as List);
  }

  var _repository = AppModule.to.getDependency<EquipeRepository>();

  void setEquipe(Equipe equipe) {
    _documentId = equipe.documentId();
    setNomeEquipe(equipe.nomeEquipe);
    setEstilo(equipe.estilo);
    setLocal(equipe.local);
    setCapitao(equipe.capitao);
    setFoneCampo(equipe.foneCampo);
    setInfo(equipe.info);
    setVlrCancha(equipe.vlrCancha);
    setImagem(equipe.imagem);
    setTotalJogadores(equipe.totalJogadores);
    setActive(equipe.active);
    setHorario(equipe.horario);

    //setListaAtletas(equipe.listaAtletas);
  }

  var _horarioController = BehaviorSubject<DateTime>();
  Stream<DateTime> get outHorario => _horarioController.stream;
  var _nomeEquipeController = BehaviorSubject<String>();
  Stream<String> get outNomeEquipe => _nomeEquipeController.stream;
  var _localController = BehaviorSubject<String>();
  Stream<String> get outLocal => _localController.stream;
  var _estiloController = BehaviorSubject<String>();
  Stream<String> get outEstilo => _estiloController.stream;
  var _infoController = BehaviorSubject<String>();
  Stream<String> get outInfo => _infoController.stream;
  var _imagemController = BehaviorSubject<String>();
  Stream<String> get outImagem => _imagemController.stream;

  var _listaAtletasController = BehaviorSubject<List<Atleta>>();
  Stream<List<Atleta>> get outListaAtletas => _listaAtletasController.stream;

  var _capitaoController = BehaviorSubject<Atleta>();
  Stream<Atleta> get outCapitao => _capitaoController.stream;
  var _foneCampoController = BehaviorSubject<String>();
  Stream<String> get outFoneCampo => _foneCampoController.stream;
  var _totalJogadoresController = BehaviorSubject<int>();
  Stream<int> get outTotalJogadores => _totalJogadoresController.stream;
  var _vlrCanchaController = BehaviorSubject<double>();
  Stream<double> get outVlrCancha => _vlrCanchaController.stream;
  var _activeController = BehaviorSubject<bool>();
  Stream<bool> get outActive => _activeController.stream;

  void setHorario(DateTime value) => _horarioController.sink.add(value);
  void setActive(bool value) => _activeController.sink.add(value);
  void setNomeEquipe(String value) => _nomeEquipeController.sink.add(value);
  void setLocal(String value) => _localController.sink.add(value);
  void setEstilo(String value) => _estiloController.sink.add(value);
  void setInfo(String value) => _infoController.sink.add(value);
  void setVlrCancha(double value) => _vlrCanchaController.sink.add(value);
  void setImagem(String value) => _imagemController.sink.add(value);
  void setTotalJogadores(int value) => _totalJogadoresController.sink.add(value);
  void setCapitao(Atleta value) => _capitaoController.sink.add(value);

  void setListaAtletas(Atleta value) => _listaAtletasController.sink.add(value as List);

  void setFoneCampo(String value) => _foneCampoController.sink.add(value);

  bool insertOrUpdate() {
    var equipe = Equipe()
    ..nomeEquipe = _nomeEquipe
    ..local = _local
    ..estilo = _estilo
    ..info = _info
    ..imagem = _imagem
    ..totalJogadores = _totalJogadores
    ..vlrCancha = _vlrCancha
    ..capitao = _capitao
    ..foneCampo = _foneCampo
    ..horario = _horario
    ..active = _active
    ..listaAtletas = _listaAtletas;

    if (_documentId?.isEmpty ?? true) {
      _repository.add(equipe);
    } else {
      _repository.update(_documentId, equipe);
    }

    return true;
  }

  @override
  void dispose() {
    _horarioController.close();
    _activeController.close();
    _nomeEquipeController.close();
    _estiloController.close();
    _localController.close();
    _infoController.close();
    _vlrCanchaController.close();
    _imagemController.close();
    _totalJogadoresController.close();
    _capitaoController.close();
    _foneCampoController.close();
    _listaAtletasController.close();
    super.dispose();
  }
}
