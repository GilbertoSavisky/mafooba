import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:mafooba/src/chat/chat_repository.dart';
import 'package:mafooba/src/models/chat_model.dart';
import 'package:rxdart/rxdart.dart';
import '../app_module.dart';

class ChatBloc extends BlocBase {
  String _documentId;

  String _ultimaMsg;
  String _nickName;
  String _fotoUrl;
  String _uid;
  DateTime _horario;
  bool _visualizado;

  ChatBloc() {
    _ultimaMsgController.listen((value) => _ultimaMsg = value);
    _fotoUrlController.listen((value) => _fotoUrl = value);
    _horarioController.listen((value) => _horario = value);
    _nickNameController.listen((value) => _nickName = value);
    _visualizadoController.listen((value) => _visualizado = value);
  }

  var _repository = AppModule.to.getDependency<ChatRepository>();

  void setChat(Chat chat) {
    _documentId = chat.documentId();

    setVisualizado(chat.visualizado);
    setUltimaMsg(chat.ultimaMsg);
    setNickName(chat.nickName);
    setFotoUrl(chat.fotoUrl);
    setHorario(chat.horario);
  }

  var _ultimaMsgController = BehaviorSubject<String>();
  Stream<String> get outUltimaMsg => _ultimaMsgController.stream;
  var _nickNameController = BehaviorSubject<String>();
  Stream<String> get outNickName => _nickNameController.stream;
  var _horarioController = BehaviorSubject<DateTime>();
  Stream<DateTime> get outHorario => _horarioController.stream;
  var _fotoUrlController = BehaviorSubject<String>();
  Stream<String> get outFotoUrl => _fotoUrlController.stream;
  var _visualizadoController = BehaviorSubject<bool>();
  Stream<bool> get outVisualizado => _visualizadoController.stream;

  void setVisualizado(bool value) => _visualizadoController.sink.add(value);
  void setUltimaMsg(String value) => _ultimaMsgController.sink.add(value);
  void setNickName(String value) => _nickNameController.sink.add(value);
  void setHorario(DateTime value) => _horarioController.sink.add(value);
  void setFotoUrl(String value) => _fotoUrlController.sink.add(value);

  bool insertOrUpdate() {
    var chat = Chat()
      ..ultimaMsg = _ultimaMsg
      ..nickName = _nickName
      ..fotoUrl = _fotoUrl
      ..uid = _uid
      ..horario = _horario
      ..visualizado = _visualizado;
    print('sdfsdfssdfsdf');

    if (_documentId?.isEmpty ?? true) {
      _repository.add(chat);
    } else {
      _repository.update(_documentId, chat);
    }

    return true;
  }

  @override
  void dispose() {
    _visualizadoController.close();
    _ultimaMsgController.close();
    _nickNameController.close();
    super.dispose();
  }
}
