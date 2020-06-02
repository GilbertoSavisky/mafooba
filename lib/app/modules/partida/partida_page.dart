import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mafooba/app/modules/equipe/equipe_bloc.dart';
import 'package:mafooba/app/modules/home/home_bloc.dart';
import 'package:mafooba/app/modules/models/equipe_model.dart';
import 'package:mafooba/app/shared/fundo_gradiente.dart';
import 'package:transparent_image/transparent_image.dart';

class PartidaPage extends StatefulWidget {

  final Equipe equipe;

  PartidaPage(this.equipe);
  @override
  _PartidaPageState createState() => _PartidaPageState();
}

class _PartidaPageState extends State<PartidaPage> {

  final EquipeBloc _equipeBloc = EquipeBloc();
  final HomeBloc _homeBloc = HomeBloc();


  void initState(){
    super.initState();
    _equipeBloc.setEquipe(widget.equipe);

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.equipe.nome),
          elevation: 0,
          bottom: TabBar(
            tabs: [
              Image.asset('images/brahma.png', width: 50,),
              Image.asset('images/quilmes.png', width: 50,),
            ],
            indicatorColor: Colors.red,
          ),
        ),
        body: Stack(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.zero,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.asset('images/fundo.jpg',fit: BoxFit.fill,),
              ),
            ),
            TabBarView(
              children: [
                Stack(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage('images/Sarutobi.png'),
                                radius: 25,
                                backgroundColor: Colors.transparent,
                              ),
                              Text('Sarutobi', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage('images/hyuga-hinita.png'),
                                radius: 25,
                                backgroundColor: Colors.transparent,
                              ),
                              Text('hyuga-hinita', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage('images/inuzuka-kiba-akamaru.png'),
                                radius: 25,
                                backgroundColor: Colors.transparent,
                              ),
                              Text('Kiba', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                      ],
                    ),
                    GridView.count(
                      reverse: true,
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this produces 2 rows.
                      crossAxisCount: 3,
                      // Generate 100 widgets that display their index in the List.
                      children: List.generate(12, (index) {
                        if(index == 10){
                          return Center(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage('images/Sarutobi.png'),
                                  radius: 35,
                                  backgroundColor: Colors.transparent,
                                ),
                                Text('Sarutobi', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),)
                              ],
                            ),
                          );
                        } else
                        if(index == 6){
                          return Center(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage('images/Hatake Kakashi.png'),
                                  radius: 35,
                                  backgroundColor: Colors.transparent,
                                ),
                                Text('Hatake Kakashi', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,)
                              ],
                            ),
                          );
                        } else
                        if(index == 8){
                          return Center(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage('images/haruno-sakura.png'),
                                  radius: 35,
                                  backgroundColor: Colors.transparent,
                                ),
                                Text('Sakura', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,)

                              ],
                            ),
                          );
                        } else
                        if(index == 3){
                          return Center(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage('images/rock-lee.png'),
                                  radius: 35,
                                  backgroundColor: Colors.transparent,
                                ),
                                Text('Rock-lee', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,)

                              ],
                            ),
                          );
                        } else
                        if(index == 5){
                          return Center(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage('images/Uchiha Sasuke.png'),
                                  radius: 35,
                                  backgroundColor: Colors.transparent,
                                ),
                                Text('Sasuke', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,)

                              ],
                            ),
                          );
                        } else
                        if(index == 1){
                          return Center(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage('images/gaara-desert.png'),
                                  radius: 35,
                                  backgroundColor: Colors.transparent,
                                ),
                                Text('Gaara', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,)

                              ],
                            ),
                          );
                        } else
                        if(index == 7){
                          return Center(
                              child:
                              Icon(FontAwesome.angle_double_up, size: 120, color: Colors.black38,)
                          );
                        } else
                        if(index == 4){
                          return Center(
                              child:
                              Icon(FontAwesome.angle_double_up, size: 120, color: Colors.black38,)
                          );
                        } else
                          return

                            Center(
//                child: Text(
//                  'Item $index',
//                  style: TextStyle(color: Colors.black, fontSize: 20),
//                ),
                            );
                      }),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage('images/goten.png'),
                                radius: 25,
                                backgroundColor: Colors.transparent,
                              ),
                              Text('Goten', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage('images/vegeta.png'),
                                radius: 25,
                                backgroundColor: Colors.transparent,
                              ),
                              Text('Vegeta', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage('images/goku.png'),
                                radius: 25,
                                backgroundColor: Colors.transparent,
                              ),
                              Text('Goku', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                      ],
                    ),
                    GridView.count(
                      reverse: true,
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this produces 2 rows.
                      crossAxisCount: 3,
                      // Generate 100 widgets that display their index in the List.
                      children: List.generate(12, (index) {
                        if(index == 10){
                          return Center(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage('images/gohan.png'),
                                  radius: 35,
                                  backgroundColor: Colors.transparent,
                                ),
                                Text('Gohan', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),)
                              ],
                            ),
                          );
                        } else
                        if(index == 6){
                          return Center(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage('images/goku.png'),
                                  radius: 35,
                                  backgroundColor: Colors.transparent,
                                ),
                                Text('Goku', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,)
                              ],
                            ),
                          );
                        } else
                        if(index == 8){
                          return Center(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage('images/goten.png'),
                                  radius: 35,
                                  backgroundColor: Colors.transparent,
                                ),
                                Text('Goten', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,)

                              ],
                            ),
                          );
                        } else
                        if(index == 3){
                          return Center(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage('images/vegeta.png'),
                                  radius: 35,
                                  backgroundColor: Colors.transparent,
                                ),
                                Text('Vegeta', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,)

                              ],
                            ),
                          );
                        } else
                        if(index == 5){
                          return Center(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage('images/trunks.jpg'),
                                  radius: 35,
                                  backgroundColor: Colors.transparent,
                                ),
                                Text('Trunks', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,)

                              ],
                            ),
                          );
                        } else
                        if(index == 1){
                          return Center(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage('images/gil.jpg'),
                                  radius: 35,
                                  backgroundColor: Colors.transparent,
                                ),
                                Text('Gil', style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,)

                              ],
                            ),
                          );
                        } else
                        if(index == 7){
                          return Center(
                              child:
                              Icon(FontAwesome.angle_double_up, size: 120, color: Colors.black38,)
                          );
                        } else
                        if(index == 4){
                          return Center(
                              child:
                              Icon(FontAwesome.angle_double_up, size: 120, color: Colors.black38,)
                          );
                        } else
                          return

                            Center(
//                child: Text(
//                  'Item $index',
//                  style: TextStyle(color: Colors.black, fontSize: 20),
//                ),
                            );
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
