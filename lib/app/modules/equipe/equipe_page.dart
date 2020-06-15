import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:mafooba/app/modules/atleta/atleta_bloc.dart';
import 'package:mafooba/app/modules/equipe/equipe_bloc.dart';
import 'package:mafooba/app/modules/models/atleta_model.dart';
import 'package:mafooba/app/modules/models/equipe_model.dart';
import 'package:mafooba/app/shared/dropdown_formfield.dart';
import 'package:mafooba/app/shared/fundo_gradiente.dart';
import 'package:mafooba/app/shared/image_source_sheet.dart';
import 'package:mafooba/app/shared/input_field.dart';
import 'package:mafooba/app/shared/mascara_telefones.dart';
import 'package:mafooba/app/shared/radio_button.dart';

class EquipePage extends StatefulWidget {
  EquipePage({this.equipe, this.atleta});

  final Equipe equipe;
  final Atleta atleta;

  @override
  _EquipePageState createState() => _EquipePageState();
}

class _EquipePageState extends State<EquipePage> {
  final _dateFormat = DateFormat("dd/MM/yyyy").add_Hm();

  TextEditingController _nomeController;
  TextEditingController _localController;
  TextEditingController _infoController;
  TextEditingController _imagemController;
  TextEditingController _foneController;
  TextEditingController _qtdeAtletasController;
  TextEditingController _valorController;
  TextEditingController _tipoSorteioController;
  TextEditingController _tipoPagamentoController;
  TextEditingController _estiloController;
  TextEditingController _temposPartidaController;
  TextEditingController _duracaoPartidaController;
  TextEditingController _sortearPorController;
  TextEditingController _horaSorteioController;
  TextEditingController _capitaoController;
  PageController _pageController;

  final _bloc = EquipeBloc();
  final _atletaBloc = AtletaBloc();
  bool onListaAtletas = false;

  int _page = 0;
  List _qtdeAtletas = [ {"display": "selecione", "value": "0",},
                        {"display": "1 x 1", "value": "1",},
                        {"display": "2 x 2", "value": "2",},
                        {"display": "3 x 3", "value": "3",},
                        {"display": "4 x 4", "value": "4",},
                        {"display": "5 x 5", "value": "5",},
                        {"display": "6 x 6", "value": "6",},
                        {"display": "7 x 7", "value": "7",},
                        {"display": "8 x 8", "value": "8",},
                        {"display": "9 x 9", "value": "9",},
                        {"display": "10 x 10", "value": "10",},
                        {"display": "11 x 11", "value": "11",},];

  List _tiposDeCampos = [{"display": "selecione", "value": "0",},
                        {"display": "Areia","value": "areia",},
                        {"display": "Grama","value": "grama",},
                        {"display": "Sintético", "value": "sintetico",},
                        {"display": "Terra", "value": "terra",},
                        {"display": "Outros", "value": "outros",}];

  List<Map<String, dynamic>>  _sortearPor =
                      [{"display": "selecione","value": "0",},
                      {"display": "Por Ordem de Confirmação", "value": "confirmacao",},
                      {"display": "Por Habilidade dos atletas", "value": "habilidade",},
                      {"display": "Por Posição dos atletas", "value": "posicao",}];

  List<Map<String, dynamic>> _duracaoPartida = [];


  @override
  void initState() {
    print('eqi = ${widget.equipe.toMap()}');
    _bloc.setEquipe(widget.equipe);
    _nomeController = TextEditingController(text: widget.equipe.nome);
    _localController = TextEditingController(text: widget.equipe.local);
    _infoController = TextEditingController(text: widget.equipe.info);
    _imagemController = TextEditingController(text: widget.equipe.imagem);
    _foneController = TextEditingController(text: widget.equipe.foneContato);
    _estiloController = TextEditingController(text: widget.equipe.estilo);
    _temposPartidaController = TextEditingController(text: widget.equipe.temposPartida);
    _valorController = TextEditingController(text: widget.equipe.valor?.toStringAsFixed(2));
    _tipoSorteioController = TextEditingController(text: widget.equipe.tipoSorteio);
    _tipoPagamentoController = TextEditingController(text: widget.equipe.tipoPagamento);
    _qtdeAtletasController = TextEditingController(text: widget.equipe.qtdeAtletas.toString());
    _duracaoPartidaController = TextEditingController(text: widget.equipe.duracaoPartida);
    _sortearPorController = TextEditingController(text: widget.equipe.sortearPor);
    _horaSorteioController = TextEditingController(text: widget.equipe.horaSorteio);
    _capitaoController = TextEditingController(text: widget.equipe.capitao.toList().toString());

    _pageController = PageController();

    carregarDuracao();

    super.initState();
  }

  void carregarDuracao(){
    for(int i = 60; i > 0; i--){
      if(i == 1){
        _duracaoPartida.add({
          'display': '00:0${i} - minuto',
          'value': i.toString()
        });
      }
      else if(i < 10) {
        _duracaoPartida.add({
          'display': '00:0${i} - minutos',
          'value': i.toString()
        });
      } else {
        _duracaoPartida.add({
          'display': '00:${i} - minutos',
          'value': i.toString()
        });
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _localController.dispose();
    _estiloController.dispose();
    _infoController.dispose();
    _imagemController.dispose();
    _foneController.dispose();
    _valorController.dispose();
    _tipoSorteioController.dispose();
    _tipoPagamentoController.dispose();
    _qtdeAtletasController.dispose();
    _temposPartidaController.dispose();
    _duracaoPartidaController.dispose();
    _sortearPorController.dispose();
    _horaSorteioController.dispose();
    _capitaoController.dispose();
    _pageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.equipe.documentId() == null ?"Criar Equipe" : 'Editar ${widget.equipe.nome}', overflow: TextOverflow.fade,),
          elevation: 0,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _page,
          onTap: (page){
            _pageController.animateToPage(
                page,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn
            );
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesome5Solid.cogs),
              title: Text('Configurações'),
            ),
          ],
        ),
        body:
          PageView(
            controller: _pageController,
            onPageChanged: (p){
              setState(() {
              _page = p;
              });
            },
            children: <Widget>[
              Stack(
                children: <Widget>[
                  FundoGradiente(),
                  Form(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      children: <Widget>[
                        StreamBuilder(
                          stream: _bloc.outImagem,
                          builder: (context, foto) {
                            return foto.hasData && foto.connectionState == ConnectionState.active ?
                            Center(
                              child: StreamBuilder<bool>(
                                  initialData: false,
                                  stream: _bloc.outLoading,
                                  builder: (context, loading) {
                                    return InkWell(
                                      child: loading.data ?
                                      Image.asset(
                                        'images/216.gif',
                                        //width: 140,
                                        height: 150,
                                      ) :
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: FadeInImage.assetNetwork(
                                          //width: 140,
                                          height: 150,
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
                            ) :
                            InkWell(
                              child: Container(
                                height: 150,
                                child: CircleAvatar(
                                  backgroundColor: Colors.black12,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add),
                                      Text('Add imagem')
                                    ],
                                  ),
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
                          },
                        ),

                        Container(
                            child: MafoobaInputField(
                              readOnly: false,
                              onChanged: _bloc.setNome,
                              obscuro: false,
                              hint: 'Nome',
                              stream: _bloc.outNome,
                              icon: FontAwesome5Solid.kaaba,
                              controller: _nomeController,
                            ),
                            padding: EdgeInsets.only(top: 10, right: 5, left: 5)
                        ),
                        Container(
                            child: MafoobaInputField(
                              readOnly: true,
                              onChanged: (s){},
                              obscuro: false,
                              hint: "'Capitão do time' - (admin)",
                              //stream: _loginBloc.outUser,
                              icon: FontAwesome5Solid.user_cog,
                              //initialValue: widget.atleta.nickName == '' || widget.atleta.nickName == null ? widget.atleta.nome : widget.atleta.nickName,
                            ),
                            padding: EdgeInsets.only(top: 10, right: 5, left: 5)
                        ),

                        Container(
                          padding: EdgeInsets.all(5),
                          child: MafoobaInputField(
                            readOnly: false,
                            icon: FontAwesome5Solid.map_marked_alt,
                            obscuro: false, hint: 'Local',
                            controller: _localController,
                            onChanged: _bloc.setLocal,
                            stream: _bloc.outLocal,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: MafoobaInputField(
                            readOnly: false,
                            icon: FontAwesome.phone,
                            obscuro: false,
                            hint: 'Contato',
                            controller: _foneController,
                            onChanged: _bloc.setFoneContato,
                            stream: _bloc.outFoneContato,
                            tipo: TextInputType.phone,
                            format: [
                              MafoobaMasked(
                                maskONE: "(XX)XXXX-XXXX",
                                maskTWO: "(XX) X XXXX-XXXX"
                              )
                            ],
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.all(5),
                          child: StreamBuilder<DateTime>(
                            stream: _bloc.outHorario,
                            initialData: DateTime.now(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) return Container();
                              return InkWell(
                                onTap: () => _selecionarDiaJogo(context, snapshot.data), //, snapshot.data),
                                child: InputDecorator(
                                  decoration:
                                  InputDecoration(labelText: "Dia e hora do Jogo",
                                    border: OutlineInputBorder(),
                                    icon: Icon(FontAwesome.calendar, color: Colors.blue[900],)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(_dateFormat.format(snapshot.data), style: TextStyle(fontSize: 18),),
                                      Icon(Icons.touch_app, color: Colors.deepOrange,),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Stack(
                children: <Widget>[
                  FundoGradiente(),
                  ListView(
                    padding: EdgeInsets.only(left: 15,right: 15),
                    children: [

                      Container(
                        child: MafoobaRadioButton(
                          valor: ['um_tempo', 'dois_tempos'],
                          valorSelecionado: _temposPartidaController.text,
                          nomeCampos: ['1 tempo', '2 tempos'],
                          caption: 'O jogo terá',
                          onChange: (valor){
                            setState(() {
                              _bloc.setTemposPartida(valor);
                              _temposPartidaController.text = valor;
                            });
                          },
                        ),
                      ),
                      _temposPartidaController.text != null && _temposPartidaController.text != ''?

//                      StreamBuilder<Object>(
//                        stream: _bloc.outDuracaoPartida,
//                        builder: (context, snapshot) {
//                          return DropdownButtonFormField(
//                            onChanged: (valor){
//                              setState(() {
//                                _duracaoPartidaController.text = valor;
//                              });
//                            },
//                            value:  _duracaoPartidaController.text,
//                            items: _duracaoPartida.map<DropdownMenuItem<String>>((item) {
//                                  return DropdownMenuItem(
//                                value: item['value'],
//                                child: Text(item['display']),
//                              );
//                            }).toList(),
//                          );
//                        }
//                      )
                      Container(
                        padding: EdgeInsets.only(top: 7),
                        child: MafoobaDropDownFF(
                          dataSource: _duracaoPartida,
                          controller: _duracaoPartidaController,
                          onChanged: _bloc.setEstilo,
                          icon: FontAwesome5.clock,
                          labelText: 'Com duração de',
                          stream: _bloc.outDuracaoPartida,
                        ),
                      )

                          : Container( padding: EdgeInsets.only(top: 5),),

                      Container(
                        padding: EdgeInsets.only(top: 5),
                        child: MafoobaRadioButton(
                          valor: ['auto', 'manual', 'nenhum'],
                          valorSelecionado: _tipoSorteioController.text,
                          nomeCampos: ['auto', 'manual', 'nenhum'],
                          caption: 'Tipo de Sorteio',
                          onChange: (valor){
                            setState(() {
                              _bloc.setTipoSorteio(valor);
                              _tipoSorteioController.text = valor;
                            });
                          },
                        ),
                      ),
                      _tipoSorteioController.text != null  && _tipoSorteioController.text != 'nenhum'?
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        child: MafoobaDropDownFF(
                          dataSource: _sortearPor,
                          onChanged: (valor){
                            setState(() {
                              _bloc.setSortearPor(valor);
                              _sortearPorController.text = valor;
                            });
                          },
                          controller: _sortearPorController,
                          icon: MaterialIcons.swap_vert,
                          stream: _bloc.outSortearPor,
                          labelText: 'Critérios para o sorteio',
                        ),
                      ) : Container( padding: EdgeInsets.only(top: 5),),

                      //horario
                      _tipoSorteioController.text != null  && _tipoSorteioController.text == 'auto'?
                          Container(
                            padding: EdgeInsets.only(bottom: 5, top: 5),
                            child: MafoobaInputField(
                              readOnly: true,
                              onChanged: (valor){},
                              onTap: _selecionarHoraSorteio,
                              obscuro: false,
                              icon: Icons.alarm_on,
                              controller: _horaSorteioController,
                            ),
                          ) : Container(),

                      Container(
                        padding: EdgeInsets.only(top: 5),
                        child: MafoobaRadioButton(
                          valor: ['por_jogo', 'mensal'],
                          valorSelecionado: _tipoPagamentoController.text,
                          nomeCampos: ['por jogo', 'mensal'],
                          caption: 'Forma de pagamento',
                          onChange: (valor){
                            setState(() {
                              _bloc.setTemposPartida(valor);
                              _tipoPagamentoController.text = valor;
                            });
                          },
                        ),
                      ),
                      _tipoPagamentoController.text != null && _tipoPagamentoController.text != '' ?
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        child: MafoobaInputField(
                          readOnly: false,
                          //stream: _bloc.outValor,
                          icon: FontAwesome5Solid.hand_holding_usd,
                          controller: _valorController,
                          tipo: TextInputType.number,
                          hint: 'Valor',
                          onChanged: (valor){
                            setState(() {
                              _bloc.setValor(valor as int);
                            });
                          },
                          obscuro: false,

                        ),
                      ) : Container( padding: EdgeInsets.only(top: 7),),

                      Container(
                        padding: EdgeInsets.only(top: 5),
                        child: MafoobaDropDownFF(
                          labelText: 'Tipo de campo',
                          icon: MaterialCommunityIcons.soccer_field,
                          controller: _estiloController,
                          dataSource: _tiposDeCampos,
                          onChanged: _bloc.setEstilo,
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.only(top: 5),
                        child: MafoobaDropDownFF(
                          hint: 'Quantos por time',
                          icon: FontAwesome5Solid.running,
                          labelText: 'Quantidade de atletas',
                          dataSource: _qtdeAtletas,
                          controller: _qtdeAtletasController,
                          onChanged: (valor){
                            setState(() {
                              _qtdeAtletasController.text = valor;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
      ),
    );
  }

  DateTime _selectedTime;

  Future _selecionarDiaJogo(BuildContext context, DateTime initialDate) async {
    final DateTime _selectedTime = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2101));
    if (_selectedTime != null) {
      //print('picked -- ${_selectedTime}');
      _selecionarHoraJogo(context, _selectedTime);
    }
  }


  Future _selecionarHoraJogo(BuildContext context, DateTime _dataSelecionada) async {
    var newDate;
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        newDate = new DateTime(_dataSelecionada.year, _dataSelecionada.month, _dataSelecionada.day, picked.hour, picked.minute);
        print('----------------------------${newDate}');
        _bloc.setHorario(newDate);
      });
    }
  }
  Future _selecionarHoraSorteio() async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        print('----------------------------${picked}');
      });
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Você tem certeza?'),
        content: new Text('Você irá voltar para a tela anterior'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Não'),
          ),
          new FlatButton(
            onPressed: () {
//              widget.equipe.atletas.forEach((f){
//
//              });
//              widget.equipe.atletasRef.forEach((f){
//              });
              Navigator.of(context).pop(true);
            },
            child: new Text('Sim'),
          ),
        ],
      ),
    ) ?? false;
  }

  String formatarTituloDuracao(){
    String tempo;
    String retorno;
    return 'formatarTituloDuracao';
  }

  String formatarTituloSorteio(){
    return ('formatarTituloSorteio');
  }
}
