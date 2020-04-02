import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:mafooba/src/equipe/equipe_bloc.dart';
import 'package:mafooba/src/models/equipe_model.dart';

class EquipePage extends StatefulWidget {
  EquipePage(this.equipe);

  final Equipe equipe;

  @override
  _EquipePageState createState() => _EquipePageState();
}

class _EquipePageState extends State<EquipePage> {
  final _dateFormat = DateFormat("dd/MM/yyyy");
  TextEditingController _nomeEquipeController;
  TextEditingController _estiloController;
  TextEditingController _localController;
  TextEditingController _horarioController;
  TextEditingController _infoController;
  TextEditingController _vlrCanchaController;
  TextEditingController _imagemController;
  TextEditingController _foneCampoController;
  TextEditingController _capitaoController;
  TextEditingController _totalJogadoresController;

  final _bloc = EquipeBloc();

  @override
  void initState() {
    _bloc.setEquipe(widget.equipe);
    _nomeEquipeController = TextEditingController(text: widget.equipe.nomeEquipe);
    _localController = TextEditingController(text: widget.equipe.local);
    _estiloController = TextEditingController(text: widget.equipe.estilo);
    _infoController = TextEditingController(text: widget.equipe.info);
//    _vlrCanchaController = TextEditingController(text: widget.equipe.vlrCancha);
    _imagemController = TextEditingController(text: widget.equipe.imagem);
    _foneCampoController = TextEditingController(text: widget.equipe.foneCampo);
//    _capitaoController = TextEditingController(text: widget.equipe.capitao);
//    _totalJogadoresController = TextEditingController(text: widget.equipe.totalJogadores);
    super.initState();
  }

  @override
  void dispose() {
    _nomeEquipeController.dispose();
    _localController.dispose();
    _estiloController.dispose();
    _infoController.dispose();
//    _vlrCanchaController.dispose();
    _imagemController.dispose();
    _foneCampoController.dispose();
//    _capitaoController.dispose();
//    _totalJogadoresController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minha Equipe"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: ListView(
            children: <Widget>[
              StreamBuilder(
                stream: _bloc.outImagem,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container(color: Colors.green, width: 100,height: 100,);
                  return Center(
                    child: Image.network(snapshot.data, width: 110,
//                      onChanged: _bloc.setImagem,
                    ),heightFactor: 1.2,
                  );
                },
              ),
              Container(
                child: TextField(
                  decoration: InputDecoration(labelText: "Nome da Equipe"),
                  controller: _nomeEquipeController,
                  onChanged: _bloc.setNomeEquipe,
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
                        controller: _localController,
                        onChanged: _bloc.setLocal,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(labelText: "Telefone"),
                        controller: _foneCampoController,
                        onChanged: _bloc.setFoneCampo,
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
                        controller: _estiloController,
                        onChanged: _bloc.setEstilo,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(labelText: "Total por time",hintText: '0'),
                        controller: _totalJogadoresController,
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
                  controller: _vlrCanchaController,
//                  onChanged: _bloc.setVlrCancha,
                ),
              ),
              Container(height: 15),
              Container(
                child: TextField(
                  decoration: InputDecoration(labelText: "Atletas"),
                  controller: _estiloController,
                  onChanged: _bloc.setEstilo,
                ),
              ),
              Container(height: 15),
              StreamBuilder<DateTime>(
                stream: _bloc.outHorario,
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
                stream: _bloc.outActive,
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
                          onChanged: _bloc.setActive,
                        ),
                      ),
                    ],
                  );
                },
              ),
              FloatingActionButton.extended (
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
      _bloc.setHorario(picked);
    }
  }
}
