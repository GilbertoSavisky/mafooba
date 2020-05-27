import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mafooba/app/modules/equipe/equipe_bloc.dart';
import 'package:mafooba/app/modules/models/atleta_model.dart';
import 'package:mafooba/app/modules/models/equipe_model.dart';
import 'package:mafooba/app/shared/fundo_gradiente.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EquipePage extends StatefulWidget {
  EquipePage(this.equipe);

  final Equipe equipe;

  @override
  _EquipePageState createState() => _EquipePageState();
}

class _EquipePageState extends State<EquipePage> {
  final _celFormat = MaskTextInputFormatter(mask: '(##) # ####-####', filter: { "#": RegExp(r'[0-9]') });
  final _foneFormat = MaskTextInputFormatter(mask: '(##) ####-#####', filter: { "#": RegExp(r'[0-9]') });
  final _dateFormat = DateFormat("dd/MM/yyyy").add_Hm();
  TextEditingController _nomeController;
  //TextEditingController _estiloController;
  TextEditingController _localController;
  TextEditingController _horarioController;
  TextEditingController _infoController;
  TextEditingController _imagemController;
  TextEditingController _foneController;
  TextEditingController _qtdeAtletasController;
  TextEditingController _valorController;
  TextEditingController _tipoSorteioController;

  final _bloc = EquipeBloc();
  bool onListaAtletas = false;
  bool onListaValor = false;
  String tipoValor = '';
  int _page = 0;

  var _estilos =['Estilo','Areia','Campo','Futsal','Futvôlei', 'Showbol', 'Society', 'Outros'];
  var _itemSelecionado = 'Estilo';
  var _qtdeAletas =['Atletas','3', '4','5','6','7', '8', '9', '10', '11'];
  var _qtdeSelecionado = 'Atletas';

  PageController _pageController;

  @override
  void initState() {
    _bloc.setEquipe(widget.equipe);
    _nomeController = TextEditingController(text: widget.equipe.nome);
    _localController = TextEditingController(text: widget.equipe.local);
    _infoController = TextEditingController(text: widget.equipe.info);
    _imagemController = TextEditingController(text: widget.equipe.imagem);
    _foneController = TextEditingController(text: widget.equipe.fone);
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
    //_estiloController.dispose();
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
              icon: new Icon(Icons.home),
              title: new Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.mail),
              title: new Text('Messages'),
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
                  ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            child: TextFormField(
                              decoration: InputDecoration(labelText: "Nome da Equipe"),
                              controller: _nomeController,
                              onChanged: _bloc.setNome,
                              validator: (texto){
                                if(texto.isEmpty){
                                  return 'Você deve preencher o nome da equipe';
                                }
                              },
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 25),
                          ),
//                          Container(
//                            child: StreamBuilder<List<Atleta>>(
//                              stream: _bloc.outCapitao,
//                              builder: (context, capitao){
//                                return capitao.hasData && capitao.connectionState == ConnectionState.active ?
//                                Container(
//                                  child: TextFormField(
//                                    decoration: InputDecoration(labelText: "Capitão da Equipe (adm.)"),
//                                    enabled: false,
//                                    initialValue: capitao.data[0].nickName,
//                                    //controller: _capitaoController,
////                              onChanged: _bloc.setNome,
//                                  ),
//                                  padding: EdgeInsets.symmetric(horizontal: 25),
//                                )
//                                    : Container();
//                              },
//                            ),
//                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: TextField(
                              decoration: InputDecoration(labelText: "Local da Cancha"),
                              controller: _localController,
                              onChanged: _bloc.setLocal,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: TextField(
                              decoration: InputDecoration(labelText: "Telefone"),
                              controller: _foneController,
                              onChanged: _bloc.setFone,
                              inputFormatters: [_celFormat],
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: StreamBuilder<DateTime>(
                          stream: _bloc.outHorario,
                          initialData: DateTime.now(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return Container();

                            return InkWell(
                              onTap: () => _selecionarDiaJogo(context, snapshot.data), //, snapshot.data),
                              child: InputDecorator(
                                decoration:
                                InputDecoration(labelText: "Dia do Jogo"),
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
                ],
              ),
              Stack(
                children: <Widget>[
                  //FundoGradiente(),
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
                                                print('...................${atleta.documentId()}');
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
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        //_bloc.setHorario(_selectedTime);
        print('......picked....${picked.hour}');
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
      this._itemSelecionado = novoItem;
    });
  }
  void _dropDownQtdeSelected(String novoItem){
    setState(() {
      this._qtdeSelecionado = novoItem;
    });
  }
}
