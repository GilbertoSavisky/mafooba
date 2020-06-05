import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';

class MafoobaDropDownFF extends StatelessWidget {

  final String titleText;
  final String hint;
  final Stream<String> stream;
  final Function(String) onChanged;
  final TextEditingController controller;
  final TextInputType tipo;
  final List dataSource;
  final String myActivityResult;

  MafoobaDropDownFF({Key key, this.titleText, this.hint, this.stream, this.onChanged, this.controller, this.tipo, this.dataSource, this.myActivityResult}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.zero,
              child: DropDownFormField(
                filled: false,
                titleText: titleText,
                hintText: hint,
                value: myActivityResult,
                onChanged: onChanged,
                dataSource: dataSource,
                textField: 'display',
                valueField: 'value',
              ),
            ),
          ],
        ),
      ),
    );
  }
}