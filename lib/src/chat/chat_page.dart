import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../models/chat_model.dart';
import 'chat_bloc.dart';

class ChatPage extends StatefulWidget {
  ChatPage(this.chat, this.currentUser);

  final Chat chat;
  final FirebaseUser currentUser;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isComposing = false;
  final _dateFormat = DateFormat('dd-MM-yyyy – kk:mm');
  bool mine = false;
  bool _isLoading = false;
  TextEditingController _ultimaMsgController;

  final _bloc = ChatBloc();

  void _reset() {
    _ultimaMsgController.clear();
    setState(() {
      _isComposing = false;
    });
  }

  void _sendMessage({File imgFile}) async {

    Map<String, dynamic> data = {};

    if (imgFile != null) {
      StorageUploadTask task = FirebaseStorage.instance
          .ref()
          .child('mensagens')
          .child(widget.chat.nickName)
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(imgFile);

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

    data['horario'] = DateTime.now();
    data['visualizado'] = false;
    data['uid'] = widget.currentUser.uid;

    if (_ultimaMsgController.text != '') {
      if (_bloc.insertOrUpdate()) {
        _bloc.setHorario(DateTime.now());
        Navigator.of(context);
        data['mensagem'] = _ultimaMsgController.text;
      }
    }
    Firestore.instance
        .collection('mensagens')
        .document(widget.chat.documentId())
        .collection('mensagem')
        .add(data);
  }

  @override
  void initState() {
    _bloc.setChat(widget.chat);
    _ultimaMsgController = TextEditingController(text: widget.chat.ultimaMsg);
    super.initState();
  }

  @override
  void dispose() {
    _ultimaMsgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
            margin: EdgeInsets.only(left: 10),
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.chat.fotoUrl),
            )),
        title: Text(widget.chat.nickName),
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('mensagens')
                .document(widget.chat.documentId())
                .collection('mensagem')
                .orderBy('horario', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
//                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                default:
                  return snapshot.hasData
                      ? Expanded(
                          child: ListView.builder(
                            reverse: true,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              mine = snapshot.data.documents[index].data['uid'] == widget.currentUser?.uid;
//                              print('snapshot+++++++++++ ${snapshot.data.documents[index].data['uid']}+++++');
//                              print('currentUser+++++++++++ ${widget.currentUser?.uid}+++++');
//                              print('mine+++++++++++ ${mine}+++++');
                              return snapshot.data.documents[index].data['imagem'] != null ?

                              ListTile(
                                title:
                                Column(
                                  crossAxisAlignment: !mine ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Card(
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Image.network(snapshot.data.documents[index].data['imagem'],
                                              height: 330,
                                            ),
                                            Column(
                                              children: <Widget>[
                                                Container(
                                                  child: Text(_dateFormat.format(widget.chat.horario),
                                                    style: TextStyle(
                                                        color: Colors.blueAccent,
                                                        fontSize: 12,
                                                        letterSpacing: 0.1
                                                    ),
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
                                      color: !mine ? Color.fromARGB(-10, 220, 255, 223) : Color.fromARGB(-5, 250, 252, 220),
                                    ),
                                  ],
                                ),
                              )
                              :


                              ListTile(
                                title:
                                Column(
                                  crossAxisAlignment: !mine ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Card(
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment: !mine ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(snapshot.data.documents[index].data['mensagem'],
                                              style: TextStyle(
                                                fontSize: 17
                                              ),
                                              textAlign:  TextAlign.start,
                                            ),
                                            Container(
                                              child: Text(_dateFormat.format(widget.chat.horario),
                                                style: TextStyle(
                                                  color: Colors.blueAccent,
                                                  fontSize: 12,
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
                              );
                            },
                          ),
                        )
                      : Container();
              }
            },
          ),
          _isLoading ? LinearProgressIndicator() : Container(),
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
                    controller: _ultimaMsgController,
                    onChanged: (texto) {
                      setState(() {
                        _bloc.setUltimaMsg(texto);
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
