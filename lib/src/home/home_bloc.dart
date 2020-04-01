import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:mafooba/src/atleta/atleta_repository.dart';
import 'package:mafooba/src/chat/chat_repository.dart';
import 'package:mafooba/src/equipe/equipe_repository.dart';

import '../app_module.dart';

class                       HomeBloc extends BlocBase {
  var _repositoryAtleta = AppModule.to.getDependency<AtletaRepository>();
  get atleta => _repositoryAtleta.atleta;

  var _repositoryEquipe = AppModule.to.getDependency<EquipeRepository>();
  get equipe => _repositoryEquipe.equipe;

  var _repositoryChat = AppModule.to.getDependency<ChatRepository>();
  get chat => _repositoryChat.chat;
  
  void deleteAtleta(String documentId) => _repositoryAtleta.delete(documentId);
  void deleteEquipe(String documentId) => _repositoryEquipe.delete(documentId);
  void deleteChat(String documentId) => _repositoryChat.delete(documentId);

  @override
  void dispose() {
    super.dispose();
  }
}
