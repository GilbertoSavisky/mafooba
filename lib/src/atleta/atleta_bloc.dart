import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:mafooba/src/models/atleta_model.dart';
import 'package:mafooba/src/atleta/atleta_repository.dart';
import 'package:rxdart/rxdart.dart';
import '../app_module.dart';

class AtletaBloc extends BlocBase {
  String _documentId;

  String _nome;
  bool _isGoleiro;
  bool _isAtivo;
  int _faltas;
  String _posicao;
  String _email;
  String _fone;
  String _fotoUrl;
  String _habilidade;

  PersonBloc() {
    _nomeController.listen((value) => _nome = value);
    _isGoleiroController.listen((value) => _isGoleiro = value);
    _isAtivoController.listen((value) => _isAtivo = value);
    _faltasController.listen((value) => _faltas = value);
    _posicaoController.listen((value) => _posicao = value);
    _emailController.listen((value) => _email = value);
    _foneController.listen((value) => _fone = value);
    _fotoUrlController.listen((value) => _fotoUrl = value);
    _habilidadeController.listen((value) => _habilidade = value);
  }

  var _repository = AppModule.to.getDependency<AtletaRepository>();

  void setAtleta(Atleta atleta) {
    _documentId = atleta.documentId();
    setNome(atleta.nome);
    setPosicao(atleta.posicao);
    setIsGoleiro(atleta.isGoleiro);
    setIsAtivo(atleta.isAtivo);
    setFaltas(atleta.faltas);
    setEmail(atleta.email);
    setFone(atleta.fone);
    setFotoUrl(atleta.fotoUrl);
  }

  var _nomeController = BehaviorSubject<String>();
  Stream<String> get outNome => _nomeController.stream;
  var _isGoleiroController = BehaviorSubject<bool>();
  Stream<bool> get outIsGoleiro => _isGoleiroController.stream;
  var _isAtivoController = BehaviorSubject<bool>();
  Stream<bool> get outIsAtivo => _isAtivoController.stream;
  var _faltasController = BehaviorSubject<int>();
  Stream<int> get outFaltas => _faltasController.stream;
  var _posicaoController = BehaviorSubject<String>();
  Stream<String> get outPosicao => _posicaoController.stream;
  var _foneController = BehaviorSubject<String>();
  Stream<String> get outFone => _foneController.stream;
  var _fotoUrlController = BehaviorSubject<String>();
  Stream<String> get outFotoUrl => _fotoUrlController.stream;
  var _emailController = BehaviorSubject<String>();
  Stream<String> get outEmail => _emailController.stream;
  var _habilidadeController = BehaviorSubject<String>();
  Stream<String> get outHabilidade => _habilidadeController.stream;


  void setNome(String value) => _nomeController.sink.add(value);
  void setIsGoleiro(bool value) => _isGoleiroController.sink.add(value);
  void setIsAtivo(bool value) => _isAtivoController.sink.add(value);
  void setFaltas(int value) => _faltasController.sink.add(value);
  void setPosicao(String value) => _posicaoController.sink.add(value);
  void setFone(String value) => _foneController.sink.add(value);
  void setFotoUrl(String value) => _fotoUrlController.sink.add(value);
  void setEmail(String value) => _emailController.sink.add(value);
  void setHabilidade(String value) => _habilidadeController.sink.add(value);



  bool insertOrUpdate() {
    var atleta = Atleta()
    ..nome = _nome
    ..isGoleiro = _isGoleiro
    ..isAtivo =_isAtivo
    ..faltas = _faltas
    ..posicao = _posicao
    ..email = _email
    ..fone = _fone
    ..fotoUrl = _fotoUrl
    ..habilidade = _habilidade;

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
    _isGoleiroController.close();
    _isAtivoController.close();
    _faltasController.close();
    _posicaoController.close();
    _emailController.close();
    _foneController.close();
    _fotoUrlController.close();
    _habilidadeController.close();
    super.dispose();
  }
}
