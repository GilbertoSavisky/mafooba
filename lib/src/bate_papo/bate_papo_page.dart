import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mafooba/src/bate_papo/bate_papo_bloc.dart';
import 'package:mafooba/src/bate_papo/mensagens_bloc.dart';
import 'package:mafooba/src/home/home_bloc.dart';
import 'package:mafooba/src/models/atleta_model.dart';
import 'package:mafooba/src/models/bate_papo_model.dart';
import 'package:mafooba/src/models/mensagens_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:transparent_image/transparent_image.dart';

class BatePapoPage extends StatefulWidget {
  BatePapoPage(this._atleta, this._currentUser);

  final Atleta _atleta;
  final FirebaseUser _currentUser;

  @override
  _BatePapoPageState createState() => _BatePapoPageState();
}

class _BatePapoPageState extends State<BatePapoPage> {
  TextEditingController _textoController;


  final _blocBatePapo = BatePapoBloc();
  final _blocHome = HomeBloc();
  final _blocMsg = MensagensBloc();

  final _dateFormat = DateFormat('dd/MM/yy').add_Hm();
  bool _isComposing = false;
  bool mine = false;
  bool _isLoading = false;
  List<BatePapo> _listaBatePapo = [];
  BatePapo _batePapo = BatePapo();
  Mensagens _msg = Mensagens();



  @override
  void initState() {
    _batePapo = BatePapo();
    _batePapo.remetente = widget._currentUser.uid;
    _batePapo.destinatario = widget._atleta.documentId();
    _batePapo.visualizado = false;
    _blocBatePapo.setBatePapo(_batePapo);
    _textoController= TextEditingController(text: '');
    super.initState();
  }

  @override
  void dispose() {
    _textoController.dispose();
    super.dispose();
  }


  void _sendMessage({File imgFile, String texto}) async {

    _batePapo.visualizado = false;
    _batePapo.remetente = widget._currentUser.uid;
    _batePapo.destinatario = widget._atleta.documentId();
    Firestore.instance.collection('bate_papo').document(_batePapo?.documentId()).setData(_batePapo.toMap()).whenComplete(() async {

      if (imgFile != null) {
        StorageUploadTask task =
        FirebaseStorage.instance.ref().child('mensagens').child(
            widget._atleta.nickName != '' ? widget._atleta.nickName : widget._atleta.nome).child(DateTime.now()
            .millisecondsSinceEpoch
            .toString()).putFile(imgFile);
        setState(() {
          _isLoading = true;
        });
        StorageTaskSnapshot taskSnapshot = await task.onComplete;
        String url = await taskSnapshot.ref.getDownloadURL();
        _msg.texto = null;
        _msg.sender = widget._currentUser.uid;
        _msg.horario = DateTime.now();
        _msg.imagem = url;
        Firestore.instance.collection('bate_papo').document(_batePapo.documentId()).collection('mensagens').document().setData(_msg.toMap()).whenComplete((){
          //_isLoading = false;
          //
          setState(() {
          _isLoading = false;
        });

        });
      }
      else if (texto != '' || texto != null){
        _blocMsg.setTexto(_textoController.text);
        _blocMsg.insertOrUpdate(_batePapo);
      }


    });
  }

  void _reset() {
    _textoController.clear();
    setState(() {
      _isComposing = false;
    });
  }


  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
        Container(
            margin: EdgeInsets.only(left: 10, top: 3, bottom: 3),
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget._atleta.fotoUrl),
            )),
        title: Text(widget._atleta != null ? widget._atleta.nickName != '' ? widget._atleta.nickName : widget._atleta.nome : 'Olá'),
      ),

      body: Column(
        children: <Widget>[

          StreamBuilder<List<BatePapo>>(
            stream: _blocHome.filtrarCurrenteUserRemetente(widget._currentUser.uid),
            builder: (context, listaUserRementente){
              return (listaUserRementente.hasData && listaUserRementente.connectionState == ConnectionState.active) ?
              StreamBuilder<List<BatePapo>>(
                stream: _blocHome.filtrarCurrenteUserDestinatario(widget._currentUser.uid),
                builder: (context, listaUserDestinatario) {
                  if(listaUserDestinatario.hasData && listaUserDestinatario.connectionState == ConnectionState.active){
                    _listaBatePapo.clear();
                    _listaBatePapo.addAll(listaUserRementente.data.where((x)=> x.destinatario == widget._atleta.uid).toList());
                    _listaBatePapo.addAll(listaUserDestinatario.data.where((x)=> x.remetente == widget._atleta.uid).toList());
                  }
                  _listaBatePapo.map((data){
                    if(data != null){
                      _batePapo = data;
                      _blocBatePapo.setVisualizado(true);
//                      _blocBatePapo.setBatePapo(_batePapo);
//                      _blocBatePapo.insertOrUpdate();
                    }
                  }).toList();
                  return StreamBuilder<List<Mensagens>>(
                    stream: _blocHome.getMensagens(_batePapo?.documentId()),
                    builder: (context, listaMsg) {
                      return (listaMsg.hasData && listaMsg.connectionState == ConnectionState.active) ?
                      Expanded(
                        child:
                        ListView(
                          reverse: true,
                          children: listaMsg.data.map((msg){
                            mine = msg.sender == widget._currentUser.uid;
                            return
                              msg.texto != '' && msg.texto != null ?
                              ListTile(
                              title: Column(
                                crossAxisAlignment: !mine ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                children: <Widget>[
                                  Card(
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment: !mine ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(msg.texto,
                                            style: TextStyle(
                                                fontSize: 18
                                            ),
                                            textAlign:  TextAlign.start,
                                          ),
                                          Container(
                                            child: Text(_dateFormat.format(msg.horario),
                                              style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontSize: 10,
                                                letterSpacing: 0.1,
                                              ),
                                            ),
                                            padding: EdgeInsets.only(right: 5),
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(5),
                                    ),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: !mine ? BorderRadius.only(
                                          bottomLeft: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ) : BorderRadius.only(
                                            bottomLeft: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.lerp(Radius.elliptical(1, 1 ), Radius.elliptical(1, 2), 10)
                                        ),
                                        side: BorderSide(color: Colors.green)
                                    ),
                                    color: !mine ? Color.fromARGB(-10, 220, 255, 223) : Color.fromARGB(-5, 250, 252, 220),
                                    margin: !mine ? EdgeInsets.only(right: 30) : EdgeInsets.only(left: 30),
                                  ),
                                ],
                              ),
                            ): ListTile(
                                title: Column(
                                  crossAxisAlignment: !mine ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Card(
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: <Widget>[

                                            Container(

                                              child: Stack(
                                                children: <Widget>[
                                                  _isLoading ?
                                                  Container (
                                                    child: Center(
                                                      child: Image.asset('images/211.gif'),
                                                    ),
                                                  ) :
                                                  Container (
                                                    child: Center(
                                                      child: AspectRatio(
                                                        aspectRatio: 4/4,
                                                        child: Container(
                                                          child: FadeInImage.assetNetwork(
                                                            image: msg.imagem,
                                                            placeholder: ('images/211.gif'),
                                                            fit: BoxFit.fitHeight,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              width: 250,
                                              height: 250,
                                            ),



                                            Column(
                                              children: <Widget>[
                                                Container(
                                                  child: Text(_dateFormat.format(msg.horario),
                                                    style: TextStyle(
                                                        color: Colors.blueAccent,
                                                        fontSize: 10,
                                                        letterSpacing: 0.1),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        padding: EdgeInsets.all(6),

                                      ),
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: !mine ? BorderRadius.only(
                                            bottomLeft: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                            topRight: Radius.circular(12),
                                          ) : BorderRadius.only(
                                              bottomLeft: Radius.circular(12),
                                              bottomRight: Radius.circular(12),
                                              topLeft: Radius.circular(12),
                                              topRight: Radius.lerp(Radius.elliptical(1, 1 ), Radius.elliptical(1, 2), 10)
                                          ),
                                          side: BorderSide(color: Colors.green)
                                      ),

                                      color: !mine ? Color.fromARGB(-10, 220, 255, 223)
                                          : Color.fromARGB(-5, 250, 252, 220),
                                    ),
                                  ],
                                ),
                              );
                          }).toList(),
                        ),
                      ) : Expanded(
                        child: Container(),
                      );
                    }
                  );
                }
              ) : Expanded(child: Container());
            },
          ),


          Container(
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.photo_camera),
                  padding: EdgeInsets.symmetric(),
                  onPressed: () async {
                    final File imgFile =
                    await ImagePicker.pickImage(source: ImageSource.camera);
                    if (imgFile == null) return;
                    _blocMsg.setSender(widget._currentUser.uid);
                    _blocMsg.setHorario(DateTime.now());
                    _sendMessage(imgFile: imgFile);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.attach_file,
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(),


                  onPressed: () async {
                    final File imgFile =
                    await ImagePicker.pickImage(source: ImageSource.gallery);
                    if (imgFile == null) return;
                    _blocMsg.setSender(widget._currentUser.uid);
                    _blocMsg.setHorario(DateTime.now());

                    _sendMessage(imgFile: imgFile);
                  },
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration.collapsed(
                      hintText: 'Enviar mensagem',
                    ),
                    controller: _textoController,
                    onChanged: (texto) {
                      setState(() {
                        _blocMsg.setTexto(texto);
                        _isComposing = texto.isNotEmpty;
                        //
                      });
                    },
                    onSubmitted: (texto) {
                      _blocMsg.setSender(widget._currentUser.uid);
                      _blocMsg.setHorario(DateTime.now());

                      _sendMessage(texto: texto);
                      _reset();
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _isComposing
                      ? () {
                    _sendMessage();
                    _reset();
                  }
                      : null,
                ),
              ],
            ),
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
