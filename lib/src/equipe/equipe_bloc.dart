import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:intl/intl.dart';
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
  int _totalJogadores;
  Atleta _capitao;
//  List<Person> _jogadores;
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
    _foneCampoController.listen((value) => _foneCampo = value);
    _capitaoController.listen((value) => _capitao = value);
//    _jogadoresController.listen((value) => _jogadores = value as List<Person>);
    _totalJogadoresController.listen((value) => _totalJogadores = value as int);
    _activeController.listen((value) => _active = value);
  }

  var _repository = AppModule.to.getDependency<EquipeRepository>();

  void setEquipe(Equipe equipe) {
    _documentId = equipe.documentId();
    setNomeEquipe(equipe.nomeEquipe);
    setEstilo(equipe.estilo);
    setLocal(equipe.local);
//    setJogadores(equipe.jogadores);
    setCapitao(equipe.capitao);
    setFoneCampo(equipe.foneCampo);
    setInfo(equipe.info);
    setTotalJogadores(equipe.totalJogadores);
    setActive(equipe.active);
    setHorario(equipe.horario);
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

  var _jogadoresController = BehaviorSubject<Atleta>();
  Stream<Atleta> get outJogadores => _jogadoresController.stream;

  var _capitaoController = BehaviorSubject<Atleta>();
  Stream<Atleta> get outCapitao => _capitaoController.stream;

  var _foneCampoController = BehaviorSubject<String>();
  Stream<String> get outFoneCampo => _foneCampoController.stream;

  var _totalJogadoresController = BehaviorSubject<int>();
  Stream<int> get outTotalJogadores => _totalJogadoresController.stream;

  var _activeController = BehaviorSubject<bool>();
  Stream<bool> get outActive => _activeController.stream;

  void setHorario(DateTime value) => _horarioController.sink.add(value);

  void setActive(bool value) => _activeController.sink.add(value);

  void setNomeEquipe(String value) => _nomeEquipeController.sink.add(value);
  void setLocal(String value) => _localController.sink.add(value);
  void setEstilo(String value) => _estiloController.sink.add(value);
  void setInfo(String value) => _infoController.sink.add(value);
  void setTotalJogadores(int value) => _totalJogadoresController.sink.add(value);
  void setCapitao(Atleta value) => _capitaoController.sink.add(value);
//  void setJogadores(List<Person> value) => _jogadoresController.sink.add(List as Person);
  void setFoneCampo(String value) => _foneCampoController.sink.add(value);

  bool insertOrUpdate() {
    var equipe = Equipe()
      ..nomeEquipe = _nomeEquipe
      ..horario = _horario
      ..estilo = _estilo
      ..local = _local
      ..active = _active;

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
    _totalJogadoresController.close();
    _capitaoController.close();
    _jogadoresController.close();
    _foneCampoController.close();
    super.dispose();
  }
}
