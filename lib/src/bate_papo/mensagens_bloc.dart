import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:mafooba/src/bate_papo/bate_papo_repository.dart';
import 'package:mafooba/src/models/mensagens_model.dart';
import 'package:rxdart/rxdart.dart';
import '../app_module.dart';

class MensagensBloc extends BlocBase {
  String _documentId;

  DateTime _horario;
  String _imagem;
  String _texto;
  String _sender;

  MensagensBloc() {
    _horarioController.listen((value) => _horario = value);
    _imagemController.listen((value) => _imagem = value);
    _textoController.listen((value) => _texto = value);
    _senderController.listen((value) => _sender = value);

  }

  var _repository = AppModule.to.getDependency<BatePapoRepository>();

  void setMensagens(Mensagens mensagens) {
    _documentId = mensagens.documentId();

    setHorario(mensagens.horario);
    setImagem(mensagens.imagem);
    setTexto(mensagens.texto);
    setSender(mensagens.sender);
  }

  var _horarioController = BehaviorSubject<DateTime>();
  Stream<DateTime> get outHorario => _horarioController.stream;
  var _textoController = BehaviorSubject<String>();
  Stream<String> get outTexto => _textoController.stream;
  var _senderController = BehaviorSubject<String>();
  Stream<String> get outSender => _senderController.stream;
  var _imagemController = BehaviorSubject<String>();
  Stream<String> get outImagem => _imagemController.stream;

  void setHorario(DateTime value) => _horarioController.sink.add(value);
  void setImagem(String value) => _imagemController.sink.add(value);
  void setTexto(String value) => _textoController.sink.add(value);
  void setSender(String value) => _senderController.sink.add(value);

  bool insertOrUpdate() {
    var mensagens = Mensagens()
      ..horario = _horario
      ..imagem = _imagem
      ..texto = _texto
      ..sender = _sender;

    if (_documentId?.isEmpty ?? true) {
      _repository.addMensagem(mensagens);
    } else {
      _repository.updateMensagem(_documentId, mensagens);
    }

    return true;
  }

  @override
  void dispose() {
    _horarioController.close();
    _imagemController.close();
    _textoController.close();
    _senderController.close();
    super.dispose();
  }
}
