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

class BatePapoPage extends StatefulWidget {
  BatePapoPage(this._batePapo, this.currentUser);

  final BatePapo _batePapo;
  final Atleta currentUser;

  @override
  _BatePapoPageState createState() => _BatePapoPageState();
}

class _BatePapoPageState extends State<BatePapoPage> {
  TextEditingController _textoMensagem;

  final _blocBatePapo = BatePapoBloc();
  final _blocHome = HomeBloc();
  final _blocMsg = MensagensBloc();

  final _dateFormat = DateFormat('dd/MM/yy').add_Hm();
  bool _isComposing = false;
  bool mine = false;
  bool _isLoading = false;


  @override
  void initState() {
    _blocBatePapo.setBatePapo(widget._batePapo);
    _textoMensagem = TextEditingController(text: '');
    super.initState();
  }

  @override
  void dispose() {
    _textoMensagem.dispose();
    super.dispose();
  }


  void _sendMessage({File imgFile}) async {
    Map<String, dynamic> data = {};

    if (imgFile != null) {
      StorageUploadTask task =
      FirebaseStorage.instance.ref().child('mensagens').
      child(widget._batePapo.nickName).child(DateTime
          .now()
          .millisecondsSinceEpoch
          .toString()).putFile(imgFile);

      setState(() {
        _isLoading = true;
      });

      StorageTaskSnapshot taskSnapshot = await task.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();

      data['imagem'] = url;

      setState(() {
        _isLoading = false;
      });
    }

    if (_textoMensagem.text != '') {
      data['texto'] = _textoMensagem.text;
    }

    data['horario'] = DateTime.now();
    data['visualizado'] = false;
    data['sender'] = widget.currentUser.uid;

    print('.......widget._batePapo...........${widget._batePapo?.documentId()}');


    if (widget._batePapo?.documentId() == null) {
      //widget._batePapo = BatePapo();

      widget._batePapo.remetente = widget.currentUser.uid;
      //widget._batePapo.destinatario = widget._atleta.uid;
//      _bloc.insertOrUpdate();
//
//      _blocHome.batePapo;
      Firestore.instance.collection('bate_papo').add(widget._batePapo.toMap()).then((onValue){
        print('-----------------------------onValue   ${onValue.documentID}');
        Firestore.instance.collection('bate_papo')
            .document(widget._batePapo.documentId())
            .collection('mensagens')
            .add(data);

      });
    }

  }


  void _reset() {
    _textoMensagem.clear();
    setState(() {
      _isComposing = false;
    });
  }


  @override

  Widget build(BuildContext context) {
    //batePapo = widget._batePapo;
    return Scaffold(
      appBar: AppBar(
        leading: Container(
            margin: EdgeInsets.only(left: 10, top: 3, bottom: 3),
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget._batePapo.fotoUrl),
            )),
        title: Text(widget._batePapo.nickName),
      ),

      body: Column(
        children: <Widget>[
          StreamBuilder<List<Mensagens>>(
            stream: _blocHome.batePapo,
            builder: (context, listaBatePapo){
              return widget._batePapo != null ?
              StreamBuilder<List<Mensagens>>(
                stream: null,//_blocHome.getMsg(widget._batePapo.documentId()),
                builder: (context, listaMensagens){
                  return (listaMensagens.hasData && listaMensagens.connectionState == ConnectionState.active) ?
                  Expanded(
                    child: ListView(
                      reverse: true,
                      children: listaMensagens.data.map((mensagem){
                        mine = mensagem.sender == widget.currentUser.uid;

                        return listaMensagens.data.isNotEmpty ? Container(
                          child: mensagem.texto != null ?
                          ListTile(
                            title: Column(
                              crossAxisAlignment: !mine ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                              children: <Widget>[
                                Card(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment: !mine ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(mensagem.texto,
                                          style: TextStyle(
                                              fontSize: 18
                                          ),
                                          textAlign:  TextAlign.start,
                                        ),
                                        Container(
                                          child: Text(_dateFormat.format(mensagem.horario),
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
                                  elevation: 5,
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
                                        Image.network(
                                          mensagem.imagem,
                                          height: 310,
                                          width: 270,
                                        ),
                                        Column(
                                          children: <Widget>[
                                            Container(
                                              child: Text(_dateFormat.format(mensagem.horario),
                                                style: TextStyle(
                                                    color: Colors.blueAccent,
                                                    fontSize: 10,
                                                    letterSpacing: 0.1),
                                              ),
                                              padding: EdgeInsets.only(right: 5),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(5),

                                  ),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    side: BorderSide(color: Colors.green),
                                  ),

                                  color: !mine ? Color.fromARGB(-10, 220, 255, 223)
                                      : Color.fromARGB(-5, 250, 252, 220),
                                ),
                              ],
                            ),
                          ),
                        ): Expanded(child: Container());
                      }).toList(),
                    ),
                  ) : Expanded(child: Container());
                },
              )

                  : Expanded(
                child: Container(
                  color: Colors.yellow,
                ),
              );

            },
          ),

          _isLoading ? Container(
            height: 250,
            width: 250,
            child: CircularProgressIndicator(),
          ) : Container(),
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
                    _isLoading ? LinearProgressIndicator() : Container();
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
                    _isLoading ? LinearProgressIndicator() : Container();
                    _sendMessage(imgFile: imgFile);
                  },
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration.collapsed(
                      hintText: 'Enviar mensagem',
                    ),
                    controller: _textoMensagem,
                    onChanged: (texto) {
                      setState(() {
                        _blocMsg.setTexto(texto);
                        _isComposing = texto.isNotEmpty;
                        //
                      });
                    },
                    onSubmitted: (texto) {
                      _sendMessage();
                      _reset();
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _isComposing
                      ? () {
                    _isLoading ? LinearProgressIndicator() : Container();
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
