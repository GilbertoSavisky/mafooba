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
  BatePapoPage(this._atleta, this._currentUser);

  final Atleta _atleta;
  final Atleta _currentUser;

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
    _textoMensagem = TextEditingController(text: '');
    super.initState();
  }

  @override
  void dispose() {
    _textoMensagem.dispose();
    super.dispose();
  }


  void _sendMessage({File imgFile}) async {

    _blocMsg.setHorario(DateTime.now());
    _blocMsg.setSender(widget._currentUser.uid);

    _blocBatePapo.setVisualizado(false);
    _blocBatePapo.insertOrUpdate();

    if (imgFile != null) {
      StorageUploadTask task =
      FirebaseStorage.instance.ref().child('mensagens').child(
          'widget._batePapo.nickName').child(DateTime.now()
          .millisecondsSinceEpoch
          .toString()).putFile(imgFile);

      setState(() {
        _isLoading = true;
      });

      StorageTaskSnapshot taskSnapshot = await task.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();

      _blocMsg.setImagem(url);
      //_blocMsg.insertOrUpdate(widget._batePapo);

      setState(() {
        _isLoading = false;
      });
    } else if (_textoMensagem.text != '') {
      _blocMsg.setTexto(_textoMensagem.text);
      //_blocMsg.insertOrUpdate(widget._batePapo);
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
    print('--....--${widget._atleta.documentId()}');
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
            builder: (context, listaMensagens){
              return (listaMensagens.hasData && listaMensagens.connectionState == ConnectionState.active) ?
              Expanded(
                child: ListView(
                  reverse: true,
                  children: listaMensagens.data.map((msg){
                    //mine = msg.sender == widget._currentUser.uid;
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: !mine ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                        children: <Widget>[
                          Card(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: !mine ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text('msg.texto',
                                    style: TextStyle(
                                        fontSize: 18
                                    ),
                                    textAlign:  TextAlign.start,
                                  ),
                                  Container(
                                    child: Text('_dateFormat.format(msg.horario)',
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
                    );
                  }).toList(),
                ),
              ) : Expanded(child: Container( child: Text('sem dados'),));
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
