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
  final _bloc = EquipeBloc();

  @override
  void initState() {
    _bloc.setEquipe(widget.equipe);
    _nomeEquipeController = TextEditingController(text: widget.equipe.nomeEquipe);
    _localController = TextEditingController(text: widget.equipe.local);
    _nomeEquipeController = TextEditingController(text: widget.equipe.estilo);
    super.initState();
  }

  @override
  void dispose() {
    _nomeEquipeController.dispose();
    _localController.dispose();
    _estiloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas Equipes"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              Container(
                child: TextField(
                  decoration: InputDecoration(labelText: "Nome da Equipe"),
                  controller: _nomeEquipeController,
                  onChanged: _bloc.setNomeEquipe,
                ),
              ),
              Container(height: 20),Container(
                child: TextField(
                  decoration: InputDecoration(labelText: "Local da Cancha"),
                  controller: _localController,
                  onChanged: _bloc.setLocal,
                ),
              ),
              Container(height: 20),Container(
                child: TextField(
                  decoration: InputDecoration(labelText: "Estilo da Pelada"),
                  controller: _estiloController,
                  onChanged: _bloc.setEstilo,
                ),
              ),
              Container(height: 20),
              StreamBuilder<DateTime>(
                stream: _bloc.outHorario,
                initialData: DateTime.now(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();

                  return InkWell(
                    onTap: () => _selectBirthDate(context, snapshot.data),
                    child: InputDecorator(
                      decoration:
                          InputDecoration(labelText: "Data de Nascimento"),
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
              Container(height: 20),
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

  Future _selectBirthDate(BuildContext context, DateTime initialDate) async {
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
