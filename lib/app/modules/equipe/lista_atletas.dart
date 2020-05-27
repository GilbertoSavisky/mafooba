import 'package:flutter/material.dart';
import 'package:mafooba/app/modules/atleta/atleta_home_page.dart';
import 'package:mafooba/app/modules/atleta/atleta_page.dart';
import 'package:mafooba/app/modules/equipe/equipe_bloc.dart';
import 'package:mafooba/app/modules/home/home_bloc.dart';
import 'package:mafooba/app/modules/models/atleta_model.dart';
import 'package:mafooba/app/modules/models/equipe_model.dart';
import 'package:mafooba/app/shared/fundo_gradiente.dart';

class ListaAtletas extends StatefulWidget {

  final Equipe equipe;

  ListaAtletas(this.equipe);

  @override
  _ListaAtletasState createState() => _ListaAtletasState();
}

class _ListaAtletasState extends State<ListaAtletas> {

  final _equipeBloc = EquipeBloc();

  void initState(){
    super.initState();
    _equipeBloc.setEquipe(widget.equipe);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Lista de Atletas'),
      ),
      floatingActionButton:
      FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AtletaHomePage(widget.equipe)),
          );
        },
        label: Text('Adicionar Atleta'),
      ),

      body: Stack(
        children: <Widget>[
          FundoGradiente(),
          ListView(
            children: widget.equipe.atletas.map((atleta){
              return Card(
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(35.0),
                    child: FadeInImage.assetNetwork(
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                      placeholder: "images/216.gif",
                      image: atleta.fotoUrl,
                    ),
                  ),
                  title: Text(atleta.nickName != '' ? atleta.nickName : atleta.nome),
                  subtitle: Text(atleta.posicao),
                ),
              );
            }).toList()
          ),
        ],
      ),
    );
  }
}
