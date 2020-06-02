import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mafooba/app/modules/atleta/atleta_home_page.dart';
import 'package:mafooba/app/modules/equipe/equipe_bloc.dart';
import 'package:mafooba/app/modules/home/home_bloc.dart';
import 'package:mafooba/app/modules/models/atleta_model.dart';
import 'package:mafooba/app/modules/models/equipe_model.dart';
import 'package:mafooba/app/modules/models/partida_model.dart';
import 'package:mafooba/app/modules/partida/partida_bloc.dart';
import 'package:mafooba/app/shared/fundo_gradiente.dart';

class ListaAtletas extends StatefulWidget {

  final Equipe equipe;

  ListaAtletas(this.equipe);

  @override
  _ListaAtletasState createState() => _ListaAtletasState();
}

class _ListaAtletasState extends State<ListaAtletas> {

  final _equipeBloc = EquipeBloc();
  final _sorteioBloc = PartidaBloc();
  final _homeBloc = HomeBloc();
  Flushbar flush;
  bool _wasButtonClicked;


  void initState(){
    super.initState();
    _equipeBloc.setEquipe(widget.equipe);

  }

  @override
  Widget build(BuildContext context) {
    _equipeBloc.outAtletas.listen((event) {
      setState(() {
      });
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Column(
          children: <Widget>[
            StreamBuilder(
              stream: _equipeBloc.outAtletasRef,
              builder: (context, snapshot) {
                return snapshot.hasData && snapshot.connectionState == ConnectionState.active ?
                  Text('Total de ${snapshot.data.length} atletas') : Container();
              }
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Icon(MaterialCommunityIcons.check_circle_outline, size: 32, color: Colors.white,),
            onPressed: (){
              if(_equipeBloc.insertOrUpdate()){
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      floatingActionButton:
      SpeedDial(
        animatedIcon: AnimatedIcons.add_event,
        children: [
          SpeedDialChild(
            child: Icon(Icons.group_add, color: Colors.white),
            backgroundColor: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AtletaHomePage(widget.equipe)),
              );
            },
            label: 'Add Atletas',
            labelStyle: TextStyle(fontWeight: FontWeight.w500),
            labelBackgroundColor: Colors.greenAccent,
          ),
           SpeedDialChild(

            child: Icon(widget.equipe.atletas.length == 0 ? Icons.delete_outline : Icons.delete_sweep, color: Colors.white),
            backgroundColor: Colors.green,
            onTap: () {
              widget.equipe.atletasRef.clear();
              widget.equipe.atletas.clear();
              _equipeBloc.setEquipe(widget.equipe);
            },
            label: 'Limpar lista',
            labelStyle: TextStyle(fontWeight: FontWeight.w500),
            labelBackgroundColor: Colors.greenAccent,
          ),
        ],

      ),

      body: Stack(
        children: <Widget>[
          FundoGradiente(),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: StreamBuilder<List<Atleta>>(
              stream: _equipeBloc.outAtletas,
              builder: (context, atletas) {
                if(atletas.data?.length == 0 && atletas.hasData && atletas.connectionState == ConnectionState.active){
                  return
                    Center(
                    child: Container(
                      padding: EdgeInsets.all(25),
                        child: Text('Sua lista está vazia, \nadicione atletas ao seu time!',
                          style: TextStyle(color: Colors.red, fontSize: 20, ),textAlign: TextAlign.center,)),
                  );
                }
                return atletas.hasData && atletas.connectionState == ConnectionState.active ?
                  ListView(
                    children: atletas.data.map((atleta){
                      return
                      Dismissible(
                        key: Key(atleta.documentId()),
                        onDismissed: (direction){
                          _equipeBloc.removeAtleta(atleta);
                          flush = Flushbar<bool>(
                            titleText:
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center ,
                                children: [
                                  Text('Remover ${atleta.nickName != '' ? atleta.nickName : atleta.nome}?', style: TextStyle(fontSize: 18),),
                                  SizedBox(height: 15,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FlatButton(
                                        onPressed: (){
                                          flush.dismiss(true);
                                        },
                                        child: Column(
                                          children: [
                                            Text('Confirmar?', style: TextStyle(fontSize: 15, color: Colors.blue[900]),),
                                            Icon(FontAwesome.check_circle,size: 35, color: Colors.red,),
                                          ],
                                        ),
                                      ),
                                      FlatButton(
                                        onPressed: (){
                                          flush.dismiss(false);
                                        },
                                        child: Column(
                                          children: [
                                            Text('Cancelar?', style: TextStyle(fontSize: 15, color: Colors.blue[900]),),
                                            Icon(FontAwesome.reply, size: 35, color: Colors.red),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            message: ' ',
                            flushbarPosition: FlushbarPosition.BOTTOM,
                            icon: Container(
                              padding: EdgeInsets.only(left: 15),
                              child: Icon(
                                  FontAwesome.thumbs_down, size: 40, color: Colors.red),
                            ),//  Icon(Icons.check, color: Colors.red,),
                            //duration: Duration(seconds: 2),
                            borderRadius: 8,
                            backgroundColor: Colors.grey[400],
                            showProgressIndicator: true,
                            //duration: Duration(seconds: 2),
                            //titleText: Text('Remover ${atleta.nickName != '' ? atleta.nickName : atleta.nome}?', style: TextStyle(fontSize: 14),),
                            margin: EdgeInsets.all(12),
                            isDismissible: false,
                            progressIndicatorBackgroundColor: Colors.red,
                          )..show(context).then((result) {
                            setState(() { // setState() is optional here
                              _wasButtonClicked = result;
                              if(result)
                                _equipeBloc.removeAtleta(atleta);
                              else
                                _equipeBloc.addAtleta(atleta);
                            });
                          });
                        },
                        direction: DismissDirection.startToEnd,
                        child: Card(
                          margin: EdgeInsets.only(left: 10, top: 0,right: 10, bottom: 1),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: FadeInImage.assetNetwork(
                                fit: BoxFit.cover,
                                width: 40,
                                height: 40,
                                placeholder: "images/216.gif",
                                image: atleta.fotoUrl,
                              ),
                            ),
                            title: Text(atleta.nickName != '' ? atleta.nickName : atleta.nome),
                            subtitle: Text(atleta.posicao, style: TextStyle(color: atleta.posicao == 'Goleiro' ? Colors.red : Colors.teal),),
                            trailing: StreamBuilder<List<Partida>>(
                              stream: _homeBloc.sorteio(widget.equipe.documentId()),
                              builder: (context, confirmado) {
                              return  //_verificaConfirmado(confirmado.data, atleta) ?
                                Icon(FontAwesome5Solid.thumbs_up, color: Colors.green,);// :
                                //Icon(FontAwesome5Solid.thumbs_down, color: Colors.red,);
                              }
                            ),
                          ),
                        ),
                      );
                    }).toList()
                ) : Center(child: CircularProgressIndicator(backgroundColor: Colors.green,));
              },
            ),
          ),
        ],
      ),
    );
  }
  bool _verificaConfirmado (List<Partida> confirmados, Atleta atleta){
    var ret = false;
    for(int i = 0; i < confirmados.length; i++){
      confirmados[i].confirmados.forEach((element) {
        if(element.path == atleta.referencia.path){
          return ret = true;
        }
        else ret = false;
      });
    }
    return ret;
  }

}
