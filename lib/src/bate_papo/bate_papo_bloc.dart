import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:mafooba/src/bate_papo/bate_papo_repository.dart';
import 'package:mafooba/src/models/atleta_model.dart';
import 'package:mafooba/src/models/bate_papo_model.dart';
import 'package:rxdart/rxdart.dart';
import '../app_module.dart';

class BatePapoBloc extends BlocBase {
  String _documentId;

  String _destinatario;
  String _remetente;
  bool _visualizado;

  DateTime _horario;
  String _texto;
  String _sender;
  String _imagem;

  String _nome;
  String _nickName;
  String _fotoUrl;

  Atleta _atletaBatePapo;



  BatePapoBloc() {
    _destinatarioController.listen((value) => _destinatario = value);
    _remetenteController.listen((value) => _remetente = value);
    _visualizadoController.listen((value) => _visualizado = value);

    _horarioController.listen((value) => _horario = value);
    _textoController.listen((value) => _texto = value);
    _senderController.listen((value) => _sender = value);
    _imagemController.listen((value) => _imagem = value);

    _nomeController.listen((value) => _nome = value);
    _nickNameController.listen((value) => _nickName = value);
    _fotoUrlController.listen((value) => _fotoUrl = value);


  }

  var _repository = AppModule.to.getDependency<BatePapoRepository>();

  void setBatePapo(BatePapo batePapo) {
    _documentId = batePapo.documentId();

    setDestinatario(batePapo.destinatario);
    setRemetente(batePapo.remetente);
    setVisualizado(batePapo.visualizado);

    setHorario(batePapo.horario);
    setTexto(batePapo.texto);
    setImagem(batePapo.imagem);
    setSender(batePapo.sender);

    setNome(batePapo.nome);
    setNickName(batePapo.nickName);
    setFotoUrl(batePapo.fotoUrl);


  }

  var _destinatarioController = BehaviorSubject<String>();
  Stream<String> get outDestinatario => _destinatarioController.stream;
  var _remetenteController = BehaviorSubject<String>();
  Stream<String> get outRemetente => _remetenteController.stream;
  var _visualizadoController = BehaviorSubject<bool>();
  Stream<bool> get outVisualizado => _visualizadoController.stream;

  var _horarioController = BehaviorSubject<DateTime>();
  Stream<DateTime> get outHorario => _horarioController.stream;
  var _textoController = BehaviorSubject<String>();
  Stream<String> get outTexto => _textoController.stream;
  var _imagemController = BehaviorSubject<String>();
  Stream<String> get outImagem => _imagemController.stream;
  var _senderController = BehaviorSubject<String>();
  Stream<String> get outSender => _senderController.stream;

  var _nomeController = BehaviorSubject<String>();
  Stream<String> get outNome => _nomeController.stream;
  var _nickNameController = BehaviorSubject<String>();
  Stream<String> get outNickName => _nickNameController.stream;
  var _fotoUrlController = BehaviorSubject<String>();
  Stream<String> get outFotoUrl => _fotoUrlController.stream;


  void setDestinatario(String value) => _destinatarioController.sink.add(value);
  void setRemetente(String value) => _remetenteController.sink.add(value);
  void setVisualizado(bool value) => _visualizadoController.sink.add(value);

  void setHorario(DateTime value) => _horarioController.sink.add(value);
  void setTexto(String value) => _textoController.sink.add(value);
  void setImagem(String value) => _imagemController.sink.add(value);
  void setSender(String value) => _senderController.sink.add(value);

  void setNome(String value) => _nomeController.sink.add(value);
  void setNickName(String value) => _nickNameController.sink.add(value);
  void setFotoUrl(String value) => _fotoUrlController.sink.add(value);


  bool insertOrUpdate() {
    var batePapo = BatePapo()
      ..destinatario = _destinatario
      ..remetente = _remetente
      ..visualizado = _visualizado;

    if (_documentId?.isEmpty ?? true) {
      _repository.addBatePapo(batePapo);
    } else {
      _repository.updateBatePapo(_documentId, batePapo);
    }
    return true;
  }

  @override
  void dispose() {
    _destinatarioController.close();
    _remetenteController.close();
    _visualizadoController.close();

    _horarioController.close();
    _textoController.close();
    _senderController.close();
    _imagemController.close();

    _nomeController.close();
    _nickNameController.close();
    _fotoUrlController.close();

    super.dispose();
  }
}
