import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:mafooba/src/chat/chat_bloc.dart';
import 'package:mafooba/src/models/chat_model.dart';

class ChatPage extends StatefulWidget {
  ChatPage(this.chat);

  final Chat chat;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _dateFormat = DateFormat("dd/MM/yyyy");
  TextEditingController _mensagemController;
  TextEditingController _nickNameController;

  final _bloc = ChatBloc();

  @override
  void initState() {
    _bloc.setChat(widget.chat);
    _mensagemController = TextEditingController(text: widget.chat.mensagem);
    _nickNameController = TextEditingController(text: widget.chat.nickName);
    super.initState();
  }

  @override
  void dispose() {
    _mensagemController.dispose();
    _nickNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: ListView(
            children: <Widget>[
//              StreamBuilder(
//                stream: _bloc.outImagem,
//                builder: (context, snapshot) {
//                  if (!snapshot.hasData) return Container(color: Colors.green, width: 100,height: 100,);
//                  return Center(
//                    child: Image.network(snapshot.data, width: 110,
////                      onChanged: _bloc.setImagem,
//                    ),heightFactor: 1.2,
//                  );
//                },
//              ),
              Container(

                child: TextField(
                  decoration: InputDecoration(labelText: "Nome da Equipe"),
                  controller: _mensagemController,
                ),
              ),
              Container(height: 15),
              Container(
                child: TextField(
                  decoration: InputDecoration(labelText: "'Capitão' (adm. da equipe) "),
//                  controller: _localController,
//                  onChanged: _bloc.setCapitao,
                ),
              ),
              Container(height: 15),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(labelText: "Local da Cancha"),
                        controller: _nickNameController,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(labelText: "Telefone"),
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 15),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(labelText: "Estilo", hintText: 'Society, Salão'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(labelText: "Total por time",hintText: '0'),
//                        onChanged: _bloc.setTotalJogadores,
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 15),
              Container(
                child: TextField(
                  decoration: InputDecoration(labelText: "Valor da Cancha"),
//                  onChanged: _bloc.setVlrCancha,
                ),
              ),
              Container(height: 15),
              Container(
                child: TextField(
                  decoration: InputDecoration(labelText: "Estilo da Pelada"),
                ),
              ),
              Container(height: 15),
              StreamBuilder<DateTime>(
                stream: null,
                initialData: DateTime.now(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();

                  return InkWell(
                    onTap: () => _selectDiaJogo(context, snapshot.data),
                    child: InputDecorator(
                      decoration:
                      InputDecoration(labelText: "Dia do Jogo"),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(_dateFormat.format(snapshot.data)),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Container(height: 15),
              StreamBuilder(
                stream: _bloc.outVisualizado,
                initialData: true,
                builder: (context, snapshot) {
                  return Column(
                    children: <Widget>[
                      Text(
                        "Ativo",
                        textAlign: TextAlign.start,
                        style: TextStyle(),
                      ),
                      Center(
                        child: Switch(
                          value: snapshot.data,
                          onChanged: _bloc.setVisualizado,
                        ),
                      ),
                    ],
                  );
                },
              ),
              FloatingActionButton.extended(
                  label: Text("Salvar"),elevation: 5,
                  onPressed: () {
                    if (_bloc.insertOrUpdate()) {
                      Navigator.pop(context);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future _selectDiaJogo(BuildContext context, DateTime initialDate) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2101));
    if (picked != null) {
//      _bloc.setHorario(picked);
    }
  }
}
