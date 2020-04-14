import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mafooba/src/home/home_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../models/atleta_model.dart';
import 'atleta_bloc.dart';

class AtletaPage extends StatefulWidget {
  AtletaPage({this.atleta, this.documentSnapshot});

  Atleta atleta;
  DocumentSnapshot documentSnapshot;

  @override
  _AtletaPageState createState() => _AtletaPageState();
}

class _AtletaPageState extends State<AtletaPage> {
  final _foneFormat = MaskTextInputFormatter(mask: '(##) # ####-####', filter: { "#": RegExp(r'[0-9]') });
  TextEditingController _nomeController;
  TextEditingController _nickNameController;
  TextEditingController _posicaoController;
  TextEditingController _emailController;
  TextEditingController _foneController;
  TextEditingController _fotoUrlController;
  TextEditingController _habilidadeController;
  TextEditingController _faltasController;

  final GlobalKey<ScaffoldState> _snackBar = GlobalKey<ScaffoldState>();

  final _bloc = AtletaBloc();
  final _blocHome = HomeBloc();
  bool _isLoading = false;

  @override
  void initState() {
    if (widget.documentSnapshot != null) {
      widget.atleta = Atleta.fromMap(widget.documentSnapshot);
    }

    _nomeController = TextEditingController(text: widget.atleta.nome);
    _nickNameController = TextEditingController(text: widget.atleta.nickName);
    _posicaoController = TextEditingController(text: widget.atleta.posicao);
    _faltasController =
        TextEditingController(text: widget.atleta.faltas.toString());
    _emailController = TextEditingController(text: widget.atleta.email);
    _foneController = TextEditingController(text: widget.atleta.fone);
    _fotoUrlController = TextEditingController(text: widget.atleta.fotoUrl);
    _habilidadeController =
        TextEditingController(text: widget.atleta.habilidade);
    _bloc.setAtleta(widget.atleta);
    super.initState();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _nickNameController.dispose();
    _posicaoController.dispose();
    _emailController.dispose();
    _foneController.dispose();
    _fotoUrlController.dispose();
    _habilidadeController.dispose();
    super.dispose();
  }

  Future<String> trocarImagem(File imgFile) async {
    if (imgFile != null) {
      StorageUploadTask task = FirebaseStorage.instance
          .ref()
          .child('perfilAtletas')
          .child(widget.atleta.nome)
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(imgFile);

      setState(() {
        _isLoading = true;
      });

      StorageTaskSnapshot taskSnapshot = await task.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();

      _bloc.setFotoUrl(url);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _snackBar,
      appBar: AppBar(
        title: ListTile(
          title: Text(
            "Editar Perfil de \n${widget.atleta.nome}",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: ListView(
            children: <Widget>[
              StreamBuilder(
                stream: _bloc.outFotoUrl,
                builder: (context, foto) {
                  return foto.data != ''  || !foto.hasData ?  Center(

                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: InkWell(
                        child: CircleAvatar(
                          child: _isLoading ? CircularProgressIndicator(semanticsValue: 'carregando...',) : Container(),
                          backgroundImage:
                              NetworkImage(foto.hasData ? foto.data : ''),

                          maxRadius: 55,
                        ),
                        onTap: () async {
                          final File imgFile = await ImagePicker.pickImage(
                              source: ImageSource.gallery);
                          if (imgFile == null) return;
                          trocarImagem(imgFile);
                        },
                      ),
                    ),
                  ) : Center(

                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: InkWell(
                        child: CircleAvatar(
                          child: Column(
                            children: <Widget>[
                              _isLoading ? CircularProgressIndicator() : Container(),
                              CircleAvatar(
                                  child: Text('carregue sua foto...', style: TextStyle(),textAlign: TextAlign.center,),
                                radius: 55,
                              ),
                            ],
                          ),
                          radius: 55,
                        ),
                        onTap: () async {
                          final File imgFile = await ImagePicker.pickImage(
                              source: ImageSource.gallery);
                          if (imgFile == null) return;
                          trocarImagem(imgFile);
                        },
                      ),
                    ),
                  );
                },
              ),
              Container(
                child: TextField(
                  decoration: InputDecoration(
                      labelText: "Nome do Atleta",
                      labelStyle: TextStyle(color: Colors.green),
                      enabled: false),
                  controller: _nomeController,
                  onChanged: _bloc.setNome,
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(labelText: "Apelido"),
                        controller: _nickNameController,
                        onChanged: _bloc.setNickName,
                      ),
                    ),
                    StreamBuilder(
                      stream: _bloc.outIsGoleiro,
                      initialData: widget.atleta.isGoleiro,
                      builder: (context, snapshot) {
                        return Row(
                          children: <Widget>[
                            Text(
                              "Goleiro",
                              textAlign: TextAlign.start,
                              style: TextStyle(),
                            ),
                            Center(
                              child: Switch(
                                value: snapshot.data,
                                onChanged: _bloc.setIsGoleiro,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                child: TextField(
                  decoration: InputDecoration(labelText: "Celular"),
                  controller: _foneController,
                  onChanged: _bloc.setFone,
                  inputFormatters: [_foneFormat],
                ),
              ),
              Container(
                child: TextField(
                  decoration: InputDecoration(
                      labelText: "Posição",
                      hintText: 'zagueiro, meio, atacante'),
                  controller: _posicaoController,
                  onChanged: _bloc.setPosicao,
                ),
              ),
              Container(
                child: TextField(
                  decoration:
                      InputDecoration(labelText: "Informações", enabled: false),
                ),
              ),
              Container(
                child: TextField(
                  decoration: InputDecoration(
                      labelText: widget.atleta.faltas > 0 ?
                          "Você tem ${widget.atleta.faltas} faltas consecutivas" : '',
                      enabled: false,
                      labelStyle: TextStyle(
                        color: Colors.red,
                      ),
                  ),

                ),
              ),
              Padding(
                padding: EdgeInsets.all(25),
              ),
              FloatingActionButton.extended(
                  label: Text("Salvar"),
                  elevation: 5,
                  onPressed: () {
                    if (_bloc.insertOrUpdate()) {
                      _snackBar.currentState.showSnackBar(SnackBar(
                        content: Text('Dados gravados com sucesso!'),
                        backgroundColor: Colors.green,
                      ));
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
