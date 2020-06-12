import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mafooba/app/modules/atleta/atleta_page.dart';
import 'package:mafooba/app/modules/bate_papo/bkp2.dart';
import 'package:mafooba/app/modules/equipe/equipe_page.dart';
import 'package:mafooba/app/modules/equipe/lista_atletas.dart';
import 'package:mafooba/app/modules/home/home_bloc.dart';
import 'package:mafooba/app/modules/models/atleta_model.dart';
import 'package:mafooba/app/modules/models/equipe_model.dart';
import 'package:mafooba/app/modules/partida/partida_page.dart';
import 'package:mafooba/app/shared/fundo_gradiente.dart';

class EquipeHomePage extends StatefulWidget {

  EquipeHomePage(this.equipe);

  final Equipe equipe;

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
        title: Text(widget.equipe.nome),
        elevation: 0,
      ),

      body: Stack(
        children: <Widget>[
          FundoGradiente(),
          Container(
            padding: EdgeInsets.all(15),
            child:
              ListView(
                children: <Widget>[
                  Card(
                    child: ListTile(
                      leading: Icon(Foundation.torsos_all, size: 50, color: Colors.orange,),
                      title: Text('Atletas'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Adicione atletas ao seu time'),
                          //Text(_dateFormat.format(widget.equipe.horario)),
                        ],
                      ),
                      trailing: Icon(FontAwesome5Solid.indent, color: Colors.blue[800],),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListaAtletas(widget.equipe))
                        );
                      },
                    ),
                  ),Card(
                    child: ListTile(
                      leading: Icon(MaterialCommunityIcons.soccer_field, size: 50, color: Colors.teal,),
                      title: Text('Partidas'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Lista de atletas'),
                          //Text(_dateFormat.format(widget.equipe.horario)),
                        ],
                      ),
                      trailing: Icon(FontAwesome5Solid.indent, color: Colors.blue[800],),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PartidaPage(widget.equipe)),
                        );
                      },
                    ),
                  ),Card(
                    child: ListTile(
                      leading: Icon(FontAwesome5Brands.whmcs, size: 50, color: Colors.red,),
                      title: Text('Configurações'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Configure sua equipe'),
                          //Text(_dateFormat.format(widget.equipe.horario)),
                        ],
                      ),
                      trailing: Icon(FontAwesome5Solid.indent, color: Colors.blue[800],),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
//                              builder: (context) => EquipePage(widget.equipe)),
                              builder: (context) => EquipePage(widget.equipe)),
                        );
                      },
                    ),
                  ),Card(
                    child: ListTile(
                      leading: Icon(AntDesign.wechat, size: 50, color: Colors.amber,),
                      title: Text('Bate-Papo'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Sala de bate papo'),
                          //Text(_dateFormat.format(widget.equipe.horario)),
                        ],
                      ),
                      trailing: Icon(FontAwesome5Solid.indent, color: Colors.blue[800],),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Chat()),
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(FontAwesome5Solid.hand_holding_usd, size: 50, color: Colors.blue,),
                      title: Text('Finanças'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Saldo da equipe'),
                          //Text(_dateFormat.format(widget.equipe.horario)),
                        ],
                      ),
                      trailing: Icon(FontAwesome5Solid.indent, color: Colors.blue[800],),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EquipeHomePage(widget.equipe)),
                        );
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(FontAwesome5Solid.ticket_alt, size: 50, color: Colors.blue,),
                      title: Text('Testes'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('testes'),
                          //Text(_dateFormat.format(widget.equipe.horario)),
                        ],
                      ),
                      trailing: Icon(FontAwesome5Solid.indent, color: Colors.blue[800],),
                      onTap: () {
//                        Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) => MyHomePage()),
//                        );
                      },
                    ),
                  ),
                ],
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
              ..nome = "";
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AtletaPage()),
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
