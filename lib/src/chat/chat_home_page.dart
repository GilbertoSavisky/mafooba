import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mafooba/src/chat/chat_page.dart';
import 'package:mafooba/src/equipe/equipe_page.dart';
import 'package:mafooba/src/home/home_bloc.dart';
import 'package:mafooba/src/models/atleta_model.dart';
import 'package:mafooba/src/models/chat_model.dart';
import 'package:mafooba/src/models/equipe_model.dart';
import 'package:mafooba/src/atleta/atleta_page.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ChatHomePage extends StatefulWidget {
  @override
  _ChatHomePageState createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  final _bloc = HomeBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas Conversas"),
      ),

      floatingActionButton: buildSpeedDial(
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: StreamBuilder<List<Chat>>(
          stream: _bloc.chat,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();

            return Container(
              child: ListView(
                children: snapshot.data.map((chat) {
                  return Dismissible(
                    key: Key(chat.documentId()),
                    onDismissed: (direction) {
                      _bloc.deleteEquipe(chat.documentId());
                    },
                    child: ListTile(
//                      leading: chat.imagem != null ? Image.network(chat.imagem) : Container(),
                      title: Text(chat.nickName),
                      subtitle: Text(chat.mensagem),
                      trailing: Text('${chat.horario.hour.toString()}:${chat.horario.minute.toString()}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatPage(chat)),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
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
              ..active = true
              ..horario = DateTime.now()
              ..nomeEquipe = ""
              ..estilo = ""
              ..local = ""
              ..foneCampo = ""
              ..totalJogadores = 0;

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
