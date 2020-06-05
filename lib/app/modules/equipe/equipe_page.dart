import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:mafooba/app/modules/equipe/equipe_bloc.dart';
import 'package:mafooba/app/modules/models/atleta_model.dart';
import 'package:mafooba/app/modules/models/equipe_model.dart';
import 'package:mafooba/app/shared/dropdown_formfield.dart';
import 'package:mafooba/app/shared/fundo_gradiente.dart';
import 'package:mafooba/app/shared/image_source_sheet.dart';
import 'package:mafooba/app/shared/input_field.dart';
import 'package:mafooba/app/shared/radio_button.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

enum TemposPartida { UMTEMPO, DOISTEMPO }
enum TipoSorteio { MANUAL, AUTO }
enum Valor { PORDIA, MENSAL }

class EquipePage extends StatefulWidget {
  EquipePage(this.equipe);

  final Equipe equipe;

  @override
  _EquipePageState createState() => _EquipePageState();
}

class _EquipePageState extends State<EquipePage> {
  final _celFormat = MaskTextInputFormatter(mask: '(##) # ####-####', filter: { "#": RegExp(r'[0-9]') });
  MaskTextInputFormatter _foneFormat = MaskTextInputFormatter(mask: '(##) ####-#####', filter: { "#": RegExp(r'[0-9]') });
  final _dateFormat = DateFormat("dd/MM/yyyy").add_Hm();
  TextEditingController _nomeController;
  TextEditingController _localController;
  TextEditingController _horarioController;
  TextEditingController _infoController;
  TextEditingController _imagemController;
  TextEditingController _foneController;
  TextEditingController _qtdeAtletasController;
  TextEditingController _valorController;
  TextEditingController _tipoSorteioController;
  TextEditingController _estiloController;
  PageController _pageController;

  final _bloc = EquipeBloc();
  bool onListaAtletas = false;

  int _page = 0;
  List _qtdeAtletas = [{"display": "1 x 1", "value": "1 x 1",},
                      {"display": "2 x 2","value": "2 x 2",},
                      {"display": "3 x 3", "value": "3 x 3",},
                      {"display": "4 x 4", "value": "4 x 4",},
                      {"display": "5 x 5", "value": "5 x 5",},
                      {"display": "6 x 6", "value": "6 x 6",},
                      {"display": "7 x 7", "value": "7 x 7",},
                      {"display": "8 x 8", "value": "8 x 8",},
                      {"display": "9 x 9", "value": "9 x 9",},
                      {"display": "10 x 10", "value": "10 x 10",},
                      {"display": "11 x 11", "value": "11 x 11",},];

  List _tiposDeCampos = [{"display": "Areia", "value": "Areia",},
                        {"display": "Grama","value": "Grama",},
                        {"display": "Sintético", "value": "Sintético",},
                        {"display": "Terra", "value": "Terra",},
                        {"display": "Outros", "value": "Outros",}];

  List _sortearPor = [{"display": "Horário", "value": "Horário",},
                        {"display": "Confirmação","value": "Confirmação",},
                        {"display": "Habilidade", "value": "Habilidade",},
                        {"display": "Nenhum", "value": "Nenhum",}];

  List<Map<String, dynamic>> _duracaoPartida = [];


  String _tipoCampoSelecionado;
  String _qtdeSelecionado;
  String _tempoPartidaSelecionado;
  String _sorteioSelecionado;


  TemposPartida _temposPartida;
  TipoSorteio _tipoSorteio;
  Valor _valor;
  @override
  void initState() {
    _bloc.setEquipe(widget.equipe);
    _nomeController = TextEditingController(text: widget.equipe.nome);
    _localController = TextEditingController(text: widget.equipe.local);
    _infoController = TextEditingController(text: widget.equipe.info);
    _imagemController = TextEditingController(text: widget.equipe.imagem);
    _foneController = TextEditingController(text: widget.equipe.fone);
    _estiloController = TextEditingController(text: widget.equipe.estilo);
    _valorController = TextEditingController(text: widget.equipe.valor?.toStringAsFixed(2));
    _tipoSorteioController = TextEditingController(text: widget.equipe.tipoSorteio);
    _qtdeAtletasController = TextEditingController(text: widget.equipe.qtdeAtletas.toString());

    _pageController = PageController();

    carregarDuracao();

    super.initState();
  }

  void carregarDuracao(){
    for(int i = 1; i < 61; i++){
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
    _qtdeAtletasController.dispose();

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
            BottomNavigationBarItem(
                icon: Icon(Icons.people),
                title: Text('Atletas')
            )
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
                            ) : Container();
                          },
                        ),


                        Container(
                          child: StreamBuilder<List<Atleta>>(
                            stream: _bloc.outCapitao,
                            builder: (context, capitaes){
                              return capitaes.hasData && capitaes.connectionState == ConnectionState.active ?
                              ListView(
                                children: capitaes.data.map((capitao) {
                                  return TextFormField(
                                    decoration: InputDecoration(
                                        labelText: "'Capitão da equipe - (admin)'",
                                        icon: Icon(FontAwesome5Solid.user_cog, color: Colors.blue[900],),
                                        border: OutlineInputBorder(),
                                    ),
                                    initialValue: capitao.nome,
                                    enabled: false,
                                  );
                                }).toList(),
                              ) : Container();
                            },
                          ),
                          height: 75,
                          padding: EdgeInsets.all(5),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: InputField(
                            icon: FontAwesome.location_arrow,
                            obscuro: false, hint: 'Local',
                            controller: _localController,
                            onChanged: _bloc.setLocal,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: InputField(
                            icon: FontAwesome.phone,
                            obscuro: false,
                            hint: 'Contato',
                            controller: _foneController,
                            onChanged: _bloc.setFone,
                            tipo: TextInputType.phone,
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
                    padding: EdgeInsets.all(20),
                    children: [
                      MafoobaRadioButton(
                        valor: [TemposPartida.UMTEMPO, TemposPartida.DOISTEMPO],
                        grupoValor: _temposPartida,
                        nomeCampos: ['1 tempo', '2 tempo'],
                        caption: 'Tempos da partida',
                        onChange: (valor){
                          setState(() {
                            _temposPartida = valor;
                          });
                        },
                      ),
                      _temposPartida != null ? Container(
                        child: ExpansionTile(
                          title: Text(formatarTituloDuracao()),
                          leading: Icon(FontAwesome5.clock),
                          children: [
                            MafoobaDropDownFF(
                              hint: 'minutos',
                              titleText: 'Selecione quantos min para cada tempo',
                              dataSource: _duracaoPartida,
                              myActivityResult: _tempoPartidaSelecionado,
                              onChanged: (valor){
                                setState(() {
                                  _tempoPartidaSelecionado = valor;
                                });
                              },
                            ),
                          ],
                        ),
                      ) : Container( padding: EdgeInsets.only(top: 5),),
                      MafoobaRadioButton(
                        valor: [TipoSorteio.AUTO, TipoSorteio.MANUAL],
                        grupoValor: _tipoSorteio,
                        nomeCampos: ['automático', 'manual'],
                        caption: 'Tipo Sorteio',
                        onChange: (valor){
                          setState(() {
                            _tipoSorteio = valor;
                          });
                        },
                      ),
                      _tipoSorteio != null ? Container(
                        child: ExpansionTile(
                          title: Text(formatarTituloSorteio()),
                          leading: Icon(FontAwesome5Solid.random),
                          children: [
                            MafoobaDropDownFF(
                              hint: 'Sorteio',
                              titleText: 'Selecione o tipo de sorteio',
                              dataSource: _sortearPor,
                              myActivityResult: _sorteioSelecionado,
                              onChanged: (valor){
                                setState(() {
                                  _sorteioSelecionado = valor;
                                });
                              },
                            ),
                          ],
                        ),
                      ) : Container( padding: EdgeInsets.only(top: 5),),

                      MafoobaRadioButton(
                        valor: [Valor.PORDIA, Valor.MENSAL],
                        grupoValor: _valor,
                        nomeCampos: ['por partida', 'mensal'],
                        caption: 'Tipo pagamento',
                        onChange: (valor){
                          setState(() {
                            _valor = valor;
                          });
                        },
                      ),
                      _valor != null ? InputField(
                        hint: 'Valor',
                        icon: FontAwesome5Solid.money_bill,
                        obscuro: false,
                        onChanged: (s){},
                        tipo: TextInputType.number,
                      ) : Container(),
                      Container(
                        child: MafoobaDropDownFF(
                          hint: 'Selecione um tipo de campo',
                          titleText: 'Tipo de Campo',
                          dataSource: _tiposDeCampos,
                          myActivityResult: _tipoCampoSelecionado,
                          onChanged: (value){
                            setState(() {
                              _tipoCampoSelecionado = value;
                            });
                          },
                        ),
                      ),
                      Container(
                        child: MafoobaDropDownFF(
                          hint: 'Quantos por time',
                          titleText: 'Quantidade de atletas',
                          dataSource: _qtdeAtletas,
                          myActivityResult: _qtdeSelecionado,
                          onChanged: (valor){
                            setState(() {
                              _qtdeSelecionado = valor;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Stack(
                children: <Widget>[
                  FundoGradiente(),
                  ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          StreamBuilder<List<Atleta>>(
                              stream: _bloc.outAtletas,
                              builder: (context, atletas) {
                                return atletas.hasData ?
                                ExpansionTile(
                                  title: Text('Lista de Atletas'),
                                  leading: Icon(Icons.people, color: Colors.deepOrange,),
                                  trailing: Icon(!onListaAtletas ? Icons.file_download : Icons.file_upload, color: Colors.deepOrange,),
                                  onExpansionChanged: (c){
                                    setState(() {
                                      onListaAtletas = c;
                                    });
                                  },
                                  children: <Widget>[
                                    Column(
                                      children: atletas.data.map((atleta){
                                        return Card(
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              radius: 25,
                                              backgroundImage: NetworkImage(atleta.fotoUrl),
                                            ),
                                            title: Text(atleta.nickName == null || atleta.nickName == '' ? atleta.nome : atleta.nickName),
                                            trailing: GestureDetector(
                                              //key: Key(atleta.documentId()),
                                              child: atleta.selecionado ?
                                              Icon(
                                                Icons.thumb_up,
                                                color: Colors.green,
                                              ) :
                                              Icon(
                                                Icons.thumb_down,
                                                color: Colors.red,
                                              ),
                                              onTap: (){
                                                //print('...................${atleta.documentId()}');
                                              },
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ) : Container();
                              }
                          ),
                          FlatButton(
                            child: Text('Add/remover jogador'),
                            onPressed: (){
                             // Navigator.of(context).push(
                                  //MaterialPageRoute(builder: (context) => AtletaHomePage(listAtletas: atletas.data, equipe: widget.equipe,))
                              //);
                            },
                            color: Colors.green,
                          ),
                        ],
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

    if(_temposPartida != null){
      tempo = _temposPartida == TemposPartida.UMTEMPO ? '1 tempo de ' : '2 tempos de ';
    }

    if(_tempoPartidaSelecionado == null){
      retorno = 'selecione o tempo da partida';
    } else {
      retorno = _tempoPartidaSelecionado.length == 1 ? '${tempo}00:0${_tempoPartidaSelecionado} min.' : '${tempo}00:${_tempoPartidaSelecionado} min.';
    }
    return retorno;
  }

  String formatarTituloSorteio(){
    String tipo;
    String retorno;

    if(_tipoSorteio != null){
      tipo = _tipoSorteio == TipoSorteio.MANUAL ? 'tipo de sorteio manual ' : 'tipo de sorteio auto por ';
    }

    if(_sorteioSelecionado == null){
      retorno = 'selecione o tipo de sorteio';
    } else {
      retorno = _sorteioSelecionado.length == 1 ? '${tipo} ${_sorteioSelecionado}' : '${tipo} ${_sorteioSelecionado}';
    }
    return retorno;
  }
}
