import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:mafooba/src/equipe/equipe_home_page.dart';
import 'package:mafooba/src/models/atleta_model.dart';
import 'package:mafooba/src/atleta/atleta_page.dart';
import 'home_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _bloc = HomeBloc();

  final _dateFormat = DateFormat("dd/MM/yyyy");


  Widget _buildBodyBack() => Container(
    decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Color.fromARGB(-12, 0, 156, 239),
              Color.fromARGB(-43, 152, 249, 200),
              Color.fromARGB(-43, 152, 249, 200),
              Color.fromARGB(-12, 0, 156, 239),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
        )
    ),
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Mafooba (My App of FootBall)"),
        actions: <Widget>[
          IconButton(onPressed: null, icon: Icon(Icons.menu, color: Colors.white,),)
        ],
      ),

      floatingActionButton: buildSpeedDial(
      ),
      body: Stack(
        children: <Widget>[
          _buildBodyBack(),
          Container(
//            color: Colors.green[200],
            padding: EdgeInsets.only(top: 16),
            child: ListView(
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('home').snapshots(),
                  builder: (context, snapshot) {
                    print(snapshot.hasData);
                    return snapshot.hasData ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height -100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: NetworkImage(
                               snapshot.data.documents[0].data['imagem']),
                        ),
                      ),
                    )  : CircularProgressIndicator;
                  },
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
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      visible: dialVisible,
      backgroundColor: Colors.red,
//      marginBottom: 45,
//      marginRight: 300,
      child: Image.asset('images/bola.png', ),
      elevation: 10,

      curve: Curves.easeInBack,
      children: [
        SpeedDialChild(
          child: Icon(Icons.group_add, color: Colors.white),
          backgroundColor: Colors.deepOrange,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EquipeHomePage()),
            );
          },
          label: 'Equipes',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.deepOrangeAccent,
        ),
        SpeedDialChild(
          child: Icon(Icons.person_add, color: Colors.white),
          backgroundColor: Colors.amber,
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
          labelBackgroundColor: Colors.amberAccent,
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
