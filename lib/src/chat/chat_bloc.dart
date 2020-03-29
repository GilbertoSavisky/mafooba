import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:mafooba/src/chat/chat_repository.dart';
import 'package:mafooba/src/models/chat_model.dart';
import 'package:rxdart/rxdart.dart';
import '../app_module.dart';

class ChatBloc extends BlocBase {
  String _documentId;

  String _mensagem;
  String _nickName;
  String _fotoUrl;
  String _uid;
  DateTime _horario;
  bool _visualizado;

  ChatBloc() {
    _mensagemController.listen((value) => _mensagem = value);
    _nickNameController.listen((value) => _nickName = value);
    _visualizadoController.listen((value) => _visualizado = value);
  }

  var _repository = AppModule.to.getDependency<ChatRepository>();

  void setChat(Chat chat) {
    _documentId = chat.documentId();

    setVisualizado(chat.visualizado);
  }

  var _mensagemController = BehaviorSubject<String>();
  Stream<String> get outMensagem => _mensagemController.stream;
  var _nickNameController = BehaviorSubject<String>();
  Stream<String> get outNickName => _nickNameController.stream;
  var _visualizadoController = BehaviorSubject<bool>();
  Stream<bool> get outVisualizado => _visualizadoController.stream;

  void setVisualizado(bool value) => _visualizadoController.sink.add(value);
  void setMensagem(String value) => _mensagemController.sink.add(value);

  bool insertOrUpdate() {
    var chat = Chat()
      ..mensagem = _mensagem
      ..nickName = _nickName
      ..fotoUrl = _fotoUrl
      ..uid = _uid
      ..horario = _horario
      ..visualizado = _visualizado;

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
    _mensagemController.close();
    _nickNameController.close();
    super.dispose();
  }
}
