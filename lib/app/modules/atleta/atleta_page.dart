import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mafooba/app/modules/home/home_bloc.dart';
import 'package:mafooba/app/shared/fundo_gradiente.dart';
import 'package:mafooba/app/shared/image_source_sheet.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../models/atleta_model.dart';
import 'atleta_bloc.dart';

class AtletaPage extends StatefulWidget {
  AtletaPage(this.atleta);

  final Atleta atleta;

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
  TextEditingController _infoController;

  final GlobalKey<ScaffoldState> _snackBar = GlobalKey<ScaffoldState>();

  final _bloc = AtletaBloc();
  final _blocHome = HomeBloc();

  @override
  void initState() {
    _nomeController = TextEditingController(text: widget.atleta.nome);
    _nickNameController = TextEditingController(text: widget.atleta.nickName);
    _posicaoController = TextEditingController(text: widget.atleta.posicao);
    _emailController = TextEditingController(text: widget.atleta.email);
    _foneController = TextEditingController(text: widget.atleta.fone);
    _fotoUrlController = TextEditingController(text: widget.atleta.fotoUrl);
    _habilidadeController = TextEditingController(text: widget.atleta.habilidade);
    _infoController = TextEditingController(text: widget.atleta.info);
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
    _infoController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _snackBar,
      appBar: AppBar(
        title: ListTile(
          title: Text(
            "Editar Perfil de \n${widget.atleta.nome}",
            //style: TextStyle(color: Colors.white),
          ),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          FundoGradiente(),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: ListView(
              children: <Widget>[
                StreamBuilder(
                  stream: _bloc.outFotoUrl,
                  builder: (context, foto) {
                    return foto.hasData && foto.connectionState == ConnectionState.active ?
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: StreamBuilder<bool>(
                          initialData: false,
                          stream: _bloc.outLoading,
                          builder: (context, loading) {
                            return InkWell(
                              child: loading.data ?
                              Image.asset(
                                'images/216.gif',
                                width: 140,
                                height: 140,
                              ) :
                              ClipRRect(
                                borderRadius: BorderRadius.circular(70.0),
                                child: FadeInImage.assetNetwork(
                                  fit: BoxFit.cover,
                                  width: 140,
                                  height: 140,
                                  placeholder: "images/216.gif",
                                  image: foto.data,
                                ),
                              ),
                              onTap: () async {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) => ImageSourceSheet(
                                      onImageSelected: (image) {
                                        _bloc.trocarImagem(image);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                );
                              },
                            );
                          }
                        ),
                      ),
                    ) : Container();
                  },
                ),
                Container(
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: "Apelido",
                    ),
                    controller: _nickNameController,
                    onChanged: _bloc.setNickName,
                  ),
                ),
                Container(
                  child: TextField(
                    decoration: InputDecoration(labelText: "Celular",),
                    controller: _foneController,
                    onChanged: _bloc.setFone,
                    inputFormatters: [_foneFormat],
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                  stream: _bloc.outIsGoleiro,
                  initialData: widget.atleta.isGoleiro,
                  builder: (context, snapshot) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("não"),
                        Center(
                          child: Switch(
                            value: snapshot.data,
                            onChanged: _bloc.setIsGoleiro,
                            activeColor: Colors.green[800],
                          ),
                        ),
                        Text("sim"),
                      ],
                    );
                  },
                ),
                Center(child: Text('Goleiro')),
                Container(
                  child: TextField(
                    decoration:
                        InputDecoration(labelText: "Informações"),
                    controller: _infoController,
                    onChanged: _bloc.setInfo,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(18),
                ),
                SizedBox(
                  height: 50,
                  child: FloatingActionButton.extended(
                      label: Text("Salvar", style: TextStyle(fontSize: 18),),
                      elevation: 5,
                      onPressed: () {
                        if (_bloc.insertOrUpdate()) {
                          _snackBar.currentState.showSnackBar(SnackBar(
                            content: Text('Dados gravados com sucesso!'),
                            backgroundColor: Colors.green,
                          ));
                        }
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
