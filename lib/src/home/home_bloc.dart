import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:mafooba/src/equipe/equipe_repository.dart';

import '../app_module.dart';

class HomeBloc extends BlocBase {
//  var _repository = AppModule.to.getDependency<PersonRepository>();
//  get people => _repository.people;

  var _repositoryEquipe = AppModule.to.getDependency<EquipeRepository>();
  get equipe => _repositoryEquipe.equipe;

  void delete(String documentId) => _repositoryEquipe.delete(documentId);
//  var deleteEquipe(String documentId) => _repositoryEquipe.delete(documentId);

  @override
  void dispose() {
    super.dispose();
  }
}
