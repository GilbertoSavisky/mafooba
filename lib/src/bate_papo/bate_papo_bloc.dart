import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:mafooba/src/bate_papo/bate_papo_repository.dart';
import 'package:mafooba/src/models/bate_papo_model.dart';
import 'package:rxdart/rxdart.dart';
import '../app_module.dart';

class BatePapoBloc extends BlocBase {
  String _documentId;

  String _destinatarioUID;
  String _remetenteUID;

  BatePapoBloc() {
    _destinatarioUIDController.listen((value) => _destinatarioUID = value);
    _remetenteUIDController.listen((value) => _remetenteUID = value);

  }

  var _repository = AppModule.to.getDependency<BatePapoRepository>();

  void setBatePapo(BatePapo batePapo) {
    _documentId = batePapo.documentId();

    setDestinatarioUID(batePapo.destinatarioUID);
    setRemetenteUID(batePapo.remetenteUID);
  }

  var _destinatarioUIDController = BehaviorSubject<String>();
  Stream<String> get outDestinatarioUID => _destinatarioUIDController.stream;
  var _remetenteUIDController = BehaviorSubject<String>();
  Stream<String> get outRemetente => _remetenteUIDController.stream;

  void setDestinatarioUID(String value) => _destinatarioUIDController.sink.add(value);
  void setRemetenteUID(String value) => _remetenteUIDController.sink.add(value);

  bool insertOrUpdate() {
    var batePapo = BatePapo()
      ..destinatarioUID = _destinatarioUID
      ..remetenteUID = _remetenteUID;

    if (_documentId?.isEmpty ?? true) {
      _repository.addBatePapo(batePapo);
    } else {
      _repository.updateBatePapo(_documentId, batePapo);
    }
    return true;
  }

  @override
  void dispose() {
    _destinatarioUIDController.close();
    _remetenteUIDController.close();
    super.dispose();
  }
}
