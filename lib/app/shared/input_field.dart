import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mask_shifter/mask_shifter.dart';

class MafoobaInputField extends StatelessWidget {

  final IconData icon;
  final String hint;
  final bool obscuro;
  final Stream stream;
  final Function(String) onChanged;
  final TextEditingController controller;
  final TextInputType tipo;
  final Function onTap;
  final readOnly;
  final format;

  const MafoobaInputField({
    Key key,
    this.icon,
    this.hint,
    this.obscuro,
    this.stream,
    this.onChanged ,
    this.controller,
    this.tipo,
    this.onTap,
    this.readOnly,
    this.format
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        //print('..............${snapshot.data}');
          return TextFormField(
          onTap: onTap,
          readOnly: readOnly,
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            icon: Icon(icon, color: Colors.blue[900],),
            labelText: hint,
            prefix: hint == 'Valor' ? Text('R\$ ') : null,
          ),
          obscureText: obscuro,
          keyboardType: tipo,
          inputFormatters: format,
        );
      }
    );
  }
}
