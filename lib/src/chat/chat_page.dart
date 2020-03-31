import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_image/network.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../models/chat_model.dart';
import 'chat_bloc.dart';

class ChatPage extends StatefulWidget {
  ChatPage(this.chat);

  final Chat chat;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isComposing = false;
  final _dateFormat = DateFormat("dd/MM/yyyy");
  TextEditingController _ultimaMsgController;

  final _bloc = ChatBloc();

  void _reset() {
    _ultimaMsgController.clear();
    setState(() {
      _isComposing = false;
    });
  }

  void _sendMessage({File imgFile}) async {
    print(_ultimaMsgController.text);

    Map<String, dynamic> data = {};

    if (imgFile != null) {
      StorageUploadTask task = FirebaseStorage.instance
          .ref()
          .child('mensagens')
          .child(widget.chat.nickName)
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(imgFile);

      StorageTaskSnapshot taskSnapshot = await task.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();
      data['imagem'] = url;
    }

    data['horario'] = DateTime.now();
    data['visualizado'] = false;

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
            child: Image.network(widget.chat.fotoUrl)),
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
//                            print(snapshot.data.documents[1].data['mensagem']);
                              return snapshot.data.documents[index].data['imagem'] != null ?

                                Container(
                                  child: Card(
                                    child: ListTile(
                                      title:
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Image.network(snapshot.data.documents[index].data['imagem'],
                                            height: 350,
                                          ),
                                        ],
                                      ),
                                      subtitle:
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(widget.chat.nickName),
                                        ],
                                      ),

                                    ),
                                    color: Colors.amber,
                                    elevation: 10,
                                    margin: EdgeInsets.all(10),
                                    semanticContainer: true,


                                  ),
                                  color: Colors.green,
                                  width: 300,
                                )

                              :


                              ListTile(
                                title:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[

                                    Card(
                                      child: Container(
                                        child: Text(snapshot.data.documents[index].data['mensagem'],
                                        ),
                                        padding: EdgeInsets.all(5),
                                      ),
                                      //color: Colors.amber,
                                      margin: EdgeInsets.all(1),
                                      elevation: 15,
                                      borderOnForeground: true,
                                    )
                                  ],

                                ),
                                subtitle: Text(widget.chat.nickName),
                              );
                            },
                          ),
                        )
                      : Container();
              }
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
