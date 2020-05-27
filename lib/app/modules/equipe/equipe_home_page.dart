import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mafooba/app/modules/atleta/atleta_page.dart';
import 'package:mafooba/app/modules/equipe/equipe_page.dart';
import 'package:mafooba/app/modules/home/home_bloc.dart';
import 'package:mafooba/app/modules/models/atleta_model.dart';
import 'package:mafooba/app/modules/models/equipe_model.dart';
import 'package:mafooba/app/shared/fundo_gradiente.dart';

class EquipeHomePage extends StatefulWidget {
  @override
  _EquipeHomePageState createState() => _EquipeHomePageState();
}

class _EquipeHomePageState extends State<EquipeHomePage> {
  final _bloc = HomeBloc();

  final _dateFormat = DateFormat("dd/MM/yyyy").add_Hm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas Equipes"),
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            var equipe = Equipe()
              ..ativo = true
              ..horario = DateTime.now()
              ..nome = ""
              ..estilo = ''
              ..local = ""
              ..fone = ""
              ..qtdeAtletas = 0;

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EquipePage(equipe)),
            );

          },
          label: Text('Adicionar Equipe')
      ),
      body: Stack(
        children: <Widget>[
          FundoGradiente(),
          Container(
            padding: EdgeInsets.all(15),
            child: StreamBuilder<List<Equipe>>(
              stream: _bloc.equipe,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return Container(
                  child: ListView(
                    children: snapshot.data.map((equipe) {
                      return Dismissible(
                        key: Key(equipe.documentId()),
                        onDismissed: (direction) {
                          _bloc.deleteEquipe(equipe.documentId());
                        },
                        child: Card(
                          child: ListTile(
                            leading: equipe.imagem != null ? Image.network(equipe.imagem) : Container(),
                            title: Text(equipe.nome, style: TextStyle(color: Colors.black),),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Próxima pelada'),
                                Text(_dateFormat.format(equipe.horario)),
                              ],
                            ),
                            trailing: Icon(Icons.exit_to_app, color: Colors.blue[800],),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EquipePage(equipe)),
                              );
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  ScrollController scrollController;

  bool dialVisible = true;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
  }

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  Widget buildBody() {
    return ListView.builder(
      controller: scrollController,
      itemCount: 30,
      itemBuilder: (ctx, i) => ListTile(title: Text('Item $i')),
    );
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      // child: Icon(Icons.add),
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      visible: dialVisible,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.group_add, color: Colors.white),
          backgroundColor: Colors.deepOrange,
          onTap: () {
            var equipe = Equipe()
              ..ativo = true
              ..horario = DateTime.now()
              ..nome = ""
              ..estilo = ''
              ..local = ""
              ..fone = ""
              ..qtdeAtletas = 0;

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EquipePage(equipe)),
            );
          },
          label: 'Equipes',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.deepOrangeAccent,
        ),
        SpeedDialChild(
          child: Icon(Icons.person_add, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () {
            var atleta = Atleta()
              ..nome = ""
              ..isGoleiro = false;

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AtletaPage(atleta)),
            );
          },
          label: 'Atletas',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.green,
        ),
        SpeedDialChild(
          child: Icon(Icons.chat, color: Colors.white),
          backgroundColor: Colors.blue,
          onTap: () => print('THIRD CHILD'),
          labelWidget: Container(
            color: Colors.blue,
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.all(6),
            child: Text('Custom Label Widget'),
          ),
        ),
      ],
    );
  }
}
