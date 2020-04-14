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

class BatePapoPage extends StatefulWidget {
  BatePapoPage(this.atleta, this.currentUser);

  final Atleta atleta;
  final FirebaseUser currentUser;

  @override
  _BatePapoPageState createState() => _BatePapoPageState();
}

class _BatePapoPageState extends State<BatePapoPage> {
  bool _isComposing = false;
  final _dateFormat = DateFormat('yy/MM/dd').add_Hm();
  bool mine = false;
  bool _isLoading = false;
  TextEditingController _textoMensagem;
  String docID;
  BatePapo batePapo;

  final _blocHome = HomeBloc();

  final _bloc = BatePapoBloc();
  final _blocMsg = MensagensBloc();
  //Atleta atleta ;

  void _reset() {
    _textoMensagem.clear();
    setState(() {
      _isComposing = false;
    });
  }



  void _sendMessage({File imgFile}) async {
    Map<String, dynamic> data = {};

    if (imgFile != null) {
      StorageUploadTask task =
        FirebaseStorage.instance.ref().child('mensagens').
          child(widget.atleta.nickName).child(DateTime.now().millisecondsSinceEpoch.toString()).putFile(imgFile);

      setState(() {
        _isLoading = true;
      });

      StorageTaskSnapshot taskSnapshot = await task.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();

      data['imagem'] = url;
      data ['enviou uma foto...'];

      setState(() {
        _isLoading = false;

      });

    }

    if (_textoMensagem.text != '') {
      if (_bloc.insertOrUpdate()) {
        data['texto'] = _textoMensagem.text;
      }
    }

    _bloc.setDestinatarioUID(widget.atleta.uid);
    _bloc.setRemetenteUID(widget.currentUser.uid);


    data['horario'] = DateTime.now();
    data['visualizado'] = false;
    data['sender'] = widget.currentUser.uid;
    print('----------------${docID}');
    _bloc.insertOrUpdate();
    Firestore.instance.collection('bate_papo').document(docID).collection('mensagens').add(data);
  }

  @override
  void initState() {
    //_bloc.setChat(widget.chat);
    _textoMensagem = TextEditingController(text: '');
    super.initState();
  }

  @override
  void dispose() {
    _textoMensagem.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
            margin: EdgeInsets.only(left: 10, top: 3, bottom: 3),
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.atleta.fotoUrl),
            )),
        title: Text(widget.atleta.nickName),

      ),
      body: Column(
        children: <Widget>[
          StreamBuilder<List<BatePapo>>(
            stream: _blocHome.filtrarBatePapo(currentID: widget.currentUser.uid, destinatarioID: widget.atleta.uid),
            builder: (context, lista_bate_papo) {
              switch (lista_bate_papo.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                default:
                  return lista_bate_papo.data != null ? Expanded(
                    child: Stack(
                      children: <Widget>[
                        ListView(
                          children: lista_bate_papo.data.map((lista){
                            docID = lista.documentId();
                            return Container(
                            );
                          }).toList(),
                        ),
                        StreamBuilder<List<Mensagens>>(
                          stream: _blocHome.getMsg(docID),
                          builder: (context, listMensagens){
                            return listMensagens.data != null ? ListView(
                              reverse: true,
                              children: listMensagens.data.map((msg){
                                return listMensagens.data.isNotEmpty ? Container(
                                  child: msg.texto != null ? ListTile(
                                    title:
                                    Column(
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
                                          elevation: 5,
                                          color: !mine ? Color.fromARGB(-10, 220, 255, 223) : Color.fromARGB(-5, 250, 252, 220),
                                          margin: !mine ? EdgeInsets.only(right: 30) : EdgeInsets.only(left: 30),
                                        ),
                                      ],
                                    ),
                                  ) : ListTile(
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
                                                  msg.imagem,
                                                  height: 330,
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
                                                      padding: EdgeInsets.only(right: 5),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            padding: EdgeInsets.all(5),

                                          ),
                                          elevation: 5,
                                          color: !mine ? Color.fromARGB(-10, 220, 255, 223)
                                              : Color.fromARGB(-5, 250, 252, 220),
                                        ),
                                      ],
                                    ),
                                  ),
                                ) : Container();
                              }).toList(),
                            ) : Container();
                          },
                        ),
                      ],
                    ),
                  ) : Container();
              }
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
