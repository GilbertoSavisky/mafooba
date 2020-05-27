import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:mafooba/app/app_module.dart';
import 'package:mafooba/app/modules/bate_papo/bate_papo_repository.dart';
import 'package:mafooba/app/modules/models/bate_papo_model.dart';
import 'package:rxdart/rxdart.dart';

class BatePapoBloc extends BlocBase {
  String _documentId;

  String _destinatario;
  String _remetente;
  bool _visualizado;



  BatePapoBloc() {
    _destinatarioController.listen((value) => _destinatario = value);
    _remetenteController.listen((value) => _remetente = value);
    _visualizadoController.listen((value) => _visualizado = value);


  }

  var _repository = AppModule.to.getDependency<BatePapoRepository>();

  void setBatePapo(BatePapo batePapo) {
    _documentId = batePapo.documentId();

    setDestinatario(batePapo.destinatario);
    setRemetente(batePapo.remetente);
    setVisualizado(batePapo.visualizado);

    print('setBAtePapo : ${batePapo.documentId()}');

  }

  var _destinatarioController = BehaviorSubject<String>();
  Stream<String> get outDestinatario => _destinatarioController.stream;
  var _remetenteController = BehaviorSubject<String>();
  Stream<String> get outRemetente => _remetenteController.stream;
  var _visualizadoController = BehaviorSubject<bool>();
  Stream<bool> get outVisualizado => _visualizadoController.stream;



  void setDestinatario(String value) => _destinatarioController.sink.add(value);
  void setRemetente(String value) => _remetenteController.sink.add(value);
  void setVisualizado(bool value) => _visualizadoController.sink.add(value);



  bool insertOrUpdate() {
    var batePapo = BatePapo()
      ..destinatario = _destinatario
      ..remetente = _remetente
      ..visualizado = _visualizado;

    try{
      if (_documentId?.isEmpty ?? true) {
        _repository.addBatePapo(batePapo);

      } else {
        _repository.updateBatePapo(_documentId, batePapo);
      }
      //return true;
    } catch (err){
      print('erro: ${err.toString()}');
      return null;
    }
    print('insert batepop************************${_documentId}');
  }

  @override
  void dispose() {
    _destinatarioController.close();
    _remetenteController.close();
    _visualizadoController.close();


    super.dispose();
  }
}
