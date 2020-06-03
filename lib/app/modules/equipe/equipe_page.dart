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
import 'package:mafooba/app/shared/fundo_gradiente.dart';
import 'package:mafooba/app/shared/image_source_sheet.dart';
import 'package:mafooba/app/shared/input_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

enum SingingCharacter { UMTEMPO, DOISTEMPO }

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
  bool onListaValor = false;
  String tipoValor = '';

  int _page = 0;
  var _estilos =['Estilo','Areia','Campo','Sintético', 'Terra', 'Outros'];
  var _estiloSelecionado = 'Estilo';
  var _qtdeAletas =['1 x 1','2 x 2', '3 x 3', '4 x 4',' 5x5',' 6x6',' 7x7', ' 8x8', ' 9x9', '10x10', '11x11'];
  var _qtdeSelecionado = ' 4x4';

  SingingCharacter _character = SingingCharacter.UMTEMPO;

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
    super.initState();
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
          title: Text(widget.equipe.documentId() == null ?"Criar Equipe" : 'Editar ${widget.equipe.nome}'),
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
              icon: Icon(Icons.mail),
              title: Text('Messages'),
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
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
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
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: FadeInImage.assetNetwork(
                                            fit: BoxFit.cover,
                                            //width: 140,
                                            height: 180,
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
                          child: InputField(
                            icon: FontAwesome.futbol_o,
                            obscuro: false,
                            hint: 'Nome',
                            stream: _bloc.outNome,
                            controller: _nomeController,
                            onChanged: _bloc.setNome,
                          ),
                          padding: EdgeInsets.all(10),
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
                          height: 90,
                          padding: EdgeInsets.all(10),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: InputField(
                            icon: FontAwesome.location_arrow,
                            obscuro: false, hint: 'Local',
                            controller: _localController,
                            onChanged: _bloc.setLocal,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10.0),
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
                          padding: EdgeInsets.all(10),
                          child: StreamBuilder<DateTime>(
                            stream: _bloc.outHorario,
                            initialData: DateTime.now(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) return Container();
                              return InkWell(
                                onTap: () => _selecionarDiaJogo(context, snapshot.data), //, snapshot.data),
                                child: InputDecorator(
                                  decoration:
                                  InputDecoration(labelText: "Dia do Jogo",
                                    border: OutlineInputBorder(),
                                    icon: Icon(FontAwesome.calendar, color: Colors.blue[900],)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(_dateFormat.format(snapshot.data)),
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
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: InputField(
                          icon: FontAwesome5Solid.running,
                          obscuro: false,
                          hint: 'Estilo',
                          controller: _estiloController,
                          onChanged: _bloc.setEstilo,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: InputField(
                          icon: FontAwesome5Solid.exchange_alt,
                          obscuro: false,
                          hint: 'Estilo',
                          controller: _tipoSorteioController,
                          onChanged: _bloc.setTipoSorteio,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: InputField(
                          icon: FontAwesome5Solid.exchange_alt,
                          obscuro: false,
                          hint: 'Quantidade atletas por time',
                          controller: _qtdeAtletasController,
                          //onChanged: _bloc.setQtdeAtletas,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: InputField(
                          icon: FontAwesome5Solid.exchange_alt,
                          obscuro: false,
                          hint: 'Valor',
                          controller: _valorController,
                          //onChanged: _bloc.setQtdeAtletas,
                        ),
                      ),
                      Column(
                        children: [
                          Text('Quantos tempos?'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: const Text('1 tempo'),
                                  leading: Radio(
                                    value: SingingCharacter.UMTEMPO,
                                    groupValue: _character,
                                    onChanged: (SingingCharacter value) {
                                      setState(() {
                                        _character = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: const Text('2 tempos'),
                                  leading: Radio(
                                    value: SingingCharacter.DOISTEMPO,
                                    groupValue: _character,
                                    onChanged: (SingingCharacter value) {
                                      setState(() {
                                        _character = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(

                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: BoxBorder.lerp(
                                Border.all(color: Colors.white, width: 1),
                                Border.all(color: Colors.black, width: 1), 10
                            ),
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.transparent,
                          ),
                          child: DropdownButton<String>(
                            icon: Icon(Icons.keyboard_arrow_down),
                            items: _estilos.map((estilo) {
                              return DropdownMenuItem<String>(
                                value: estilo,
                                child: Container(
                                  width: 250,
                                  child: ListTile(
                                    leading: Icon(Icons.accessibility),
                                    title: Text(estilo),
                                  ),
                                ),
                              );
                            } ).toList(),
                            onChanged: (novoItem){
                              _dropDownEstiloSelected(novoItem);
                              setState(() {
                                _estiloSelecionado = novoItem;
                              });
                            },
                            value: _estiloSelecionado,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: BoxBorder.lerp(
                                Border.all(color: Colors.white, width: 1),
                                Border.all(color: Colors.black, width: 1), 10
                            ),
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.transparent,
                          ),
                          child: DropdownButton<String>(
                            icon: Icon(Icons.keyboard_arrow_down),
                            items: _qtdeAletas.map((qtd) {
                              return DropdownMenuItem<String>(
                                value: qtd,
                                child: Container(
                                  width: 250,
                                  child: ListTile(
                                    leading: Icon(Icons.accessibility),
                                    title: Text(qtd),
                                  ),
                                ),
                              );
                            } ).toList(),
                            onChanged: (novoItem){
                              _dropDownQtdeSelected(novoItem);
                              setState(() {
                                _qtdeSelecionado = novoItem;
                              });
                            },
                            value: _qtdeSelecionado,
                          ),
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
  void _dropDownEstiloSelected(String novoItem){
    setState(() {
      this._estiloSelecionado = novoItem;
    });
  }
  void _dropDownQtdeSelected(String novoItem){
    setState(() {
      this._qtdeSelecionado = novoItem;
    });
  }
}
