import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';

class MafoobaRadioButton extends StatelessWidget {
  final Function(dynamic) onChange;
  final String caption;
  final List nomeCampos;
  final List valor;
  final valorSelecionado;


  MafoobaRadioButton(
      {this.onChange,
        this.caption,
        this.nomeCampos,
        this.valorSelecionado,
        this.valor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.lerp(Border.all(color: Colors.white, width: 0),
            Border.all(color: Colors.black, width: 0), 1),
        borderRadius: BorderRadius.circular(5),
        color: Colors.transparent,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(caption),
          Flexible(
            fit: FlexFit.loose,
            child: Row(
              children: nomeCampos.map((e) {
                return
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.zero,
                      child: ListTileMoreCustomizable(
                        contentPadding: EdgeInsets.zero,
                        title: Text(nomeCampos[nomeCampos.indexOf(e)]),
                        leading: Radio(
                          activeColor: Colors.deepOrange,
                          value: valor[nomeCampos.indexOf(e)],
                          groupValue: valorSelecionado,
                          onChanged: onChange,
                        ),
                        horizontalTitleGap: 0,
                        minVerticalPadding: 0.0,
                        dense: true,
                      ),
                    ),
                  );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
