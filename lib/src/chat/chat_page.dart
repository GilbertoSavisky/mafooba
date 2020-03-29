import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  TextEditingController _mensagemController;

  final _bloc = ChatBloc();

  @override
  void initState() {
    _bloc.setChat(widget.chat);
    _mensagemController = TextEditingController(text: widget.chat.mensagem);
    super.initState();
  }

  @override
  void dispose() {
    _mensagemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.chat.documentId());
    return Scaffold(
      appBar: AppBar(
        leading: Container(
            margin: EdgeInsets.only(left: 10),
            child: Image.network(widget.chat.fotoUrl)),
        title: Text(widget.chat.nickName),
      ),
      body: Column(
        children: <Widget>[
          FutureBuilder<QuerySnapshot>(
            future: Firestore.instance.collection('mensagens').document(widget.chat.documentId()).collection('mensagem').getDocuments(),
            builder: (context, snapshot){

              return snapshot.hasData ? Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index){
                    print(snapshot.hasData);
                    return ListTile(
                      title: Text(snapshot.data.documents[index].data['mensagem']),
                    );
                  },
                ),
              ) : Container();
            },
          ),
          Container(
            child: Row(
              children: <Widget>[
                IconButton(icon: Icon(Icons.photo_camera),
                  onPressed: (){

                  },
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Enviar mensagem'),
                    onChanged: (texto){
                      setState(() {
                        _isComposing = texto.isNotEmpty;
                      });
                    },
                    onSubmitted: (texto){

                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: (){
                    _isComposing ? (){

                    }: null;
                  },
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
