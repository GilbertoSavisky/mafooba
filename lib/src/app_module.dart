import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:mafooba/src/equipe/equipe_bloc.dart';
import 'package:mafooba/src/equipe/equipe_repository.dart';
import 'package:mafooba/src/atleta/atleta_bloc.dart';
import 'package:mafooba/src/atleta/atleta_repository.dart';
import 'app_bloc.dart';
import 'app_widget.dart';

class AppModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => EquipeBloc()),
        Bloc((i) => AtletaBloc()),
        Bloc((i) => AppBloc()),
      ];

  @override
  List<Dependency> get dependencies => [
    Dependency((i) => AtletaRepository()),
    Dependency((i) => EquipeRepository()),
      ];

  @override
  Widget get view => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
