import 'package:mafooba/app/app_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:mafooba/app/app_widget.dart';
import 'package:mafooba/app/modules/atleta/atleta_bloc.dart';
import 'package:mafooba/app/modules/atleta/atleta_repository.dart';
import 'package:mafooba/app/modules/atleta/user_bloc.dart';
import 'package:mafooba/app/modules/bate_papo/bate_papo_repository.dart';
import 'package:mafooba/app/modules/bate_papo/mensagens_bloc.dart';
import 'package:mafooba/app/modules/equipe/equipe_bloc.dart';
import 'package:mafooba/app/modules/equipe/equipe_repository.dart';
import 'package:mafooba/app/modules/equipe/sorteio/sorteio_bloc.dart';
import 'package:mafooba/app/modules/equipe/sorteio/sorteio_repository.dart';
import 'package:mafooba/app/modules/login/login_bloc.dart';

class AppModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => LoginBloc()),
        Bloc((i) => AppBloc()),
        Bloc((i) => AtletaBloc()),
        Bloc((i) => EquipeBloc()),
        Bloc((i) => MensagensBloc()),
        Bloc((i) => SorteioBloc()),
        Bloc((i) => UserBloc()),
      ];

  @override
  List<Dependency> get dependencies => [
    Dependency((i) => AtletaRepository()),
    Dependency((i) => EquipeRepository()),
    Dependency((i) => BatePapoRepository()),
    Dependency((i) => SorteioRepository()),
  ];

  @override
  Widget get view => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
