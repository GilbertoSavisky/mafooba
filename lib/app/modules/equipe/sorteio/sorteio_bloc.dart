import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:mafooba/app/app_module.dart';
import 'package:mafooba/app/modules/equipe/sorteio/sorteio_repository.dart';
import 'package:mafooba/app/modules/models/sorteio_equipe_model.dart';
import 'package:rxdart/rxdart.dart';

class SorteioBloc extends BlocBase {
  String _documentId;
  String _equipeId;
  String _timeA;
  String _timeB;
  DateTime _dthr_sorteio;

  SorteioBloc() {
    _timeAController.listen((value) => _timeA = value);
    _timeBController.listen((value) => _timeB = value);
    _dthr_sorteioController.listen((value) => _dthr_sorteio = value);

  }

  var _repository = AppModule.to.getDependency<SorteioRepository>();

  void setSorteio(Sorteio sorteio) {
    _documentId = sorteio.documentId();
    setTimeA(sorteio.timeA);
    setTimeB(sorteio.timeB);
    setDtHrSorteio(sorteio.dthr_sorteio);
  }

  var _timeAController = BehaviorSubject<String>();
  Stream<String> get outTimeA => _timeAController.stream;
  var _timeBController = BehaviorSubject<String>();
  Stream<String> get outTimeB => _timeBController.stream;
  var _dthr_sorteioController = BehaviorSubject<DateTime>();
  Stream<DateTime> get outDtHrSorteio => _dthr_sorteioController.stream;


  void setTimeA(String value) => _timeAController.sink.add(value);
  void setTimeB(String value) => _timeBController.sink.add(value);
  void setDtHrSorteio(DateTime value) => _dthr_sorteioController.sink.add(value);


  bool insertOrUpdate() {
    var sorteio = Sorteio()

      ..timeA = _timeA
      ..timeB = _timeB
      ..dthr_sorteio = _dthr_sorteio;

    if (_documentId?.isEmpty ?? true) {
      _repository.add(_equipeId, sorteio);
    } else {
      _repository.update(_equipeId, _documentId, sorteio);
    }

    return true;
  }

  @override
  void dispose() {
    _timeAController.close();
    _timeBController.close();
    _dthr_sorteioController.close();
    super.dispose();
  }
}