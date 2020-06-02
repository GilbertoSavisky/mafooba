import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:mafooba/app/app_module.dart';
import 'package:mafooba/app/modules/models/partida_model.dart';
import 'package:mafooba/app/modules/partida/partida_repository.dart';
import 'package:rxdart/rxdart.dart';

class PartidaBloc extends BlocBase {
  String _documentId;
  String _equipeId;
  List _timeA;
  List _timeB;
  DateTime _dthrSorteio;
  List _confirmados;

  PartidaBloc() {
    _timeAController.listen((value) => _timeA = value);
    _timeBController.listen((value) => _timeB = value);
    _dthrSorteioController.listen((value) => _dthrSorteio = value);
    _confirmadosController.listen((value) => _confirmados = value);

  }

  var _repository = AppModule.to.getDependency<PartidaRepository>();

  void setSorteio(Partida partida) {
    _documentId = partida.documentId();
    setTimeA(partida.timeA);
    setTimeB(partida.timeB);
    setDtHrSorteio(partida.dthrSorteio);
    setConfirmados(partida.confirmados);
  }

  var _timeAController = BehaviorSubject<List>();
  Stream<List> get outTimeA => _timeAController.stream;
  var _timeBController = BehaviorSubject<List>();
  Stream<List> get outTimeB => _timeBController.stream;
  var _dthrSorteioController = BehaviorSubject<DateTime>();
  Stream<DateTime> get outDtHrSorteio => _dthrSorteioController.stream;
  var _confirmadosController = BehaviorSubject<List>();
  Stream<List> get outConfirmados => _confirmadosController.stream;


  void setTimeA(List value) => _timeAController.sink.add(value);
  void setTimeB(List value) => _timeBController.sink.add(value);
  void setDtHrSorteio(DateTime value) => _dthrSorteioController.sink.add(value);
  void setConfirmados(List value) => _confirmadosController.sink.add(value);


  bool insertOrUpdate() {
    var partida = Partida()

      ..timeA = _timeA
      ..timeB = _timeB
      ..confirmados = _confirmados
      ..dthrSorteio = _dthrSorteio;

    if (_documentId?.isEmpty ?? true) {
      _repository.add(_equipeId, partida);
    } else {
      _repository.update(_equipeId, _documentId, partida);
    }

    return true;
  }

  @override
  void dispose() {
    _timeAController.close();
    _timeBController.close();
    _dthrSorteioController.close();
    _confirmadosController.close();
    super.dispose();
  }
}