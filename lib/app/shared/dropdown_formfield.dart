import 'package:flutter/material.dart';

class MafoobaDropDownFF extends StatelessWidget {

  final String labelText;
  final String hint;
  final Stream<String> stream;
  final Function(String) onChanged;
  final TextInputType tipo;
  final List dataSource;
  final TextEditingController controller;
  final IconData icon;



  MafoobaDropDownFF({
    Key key,
    this.labelText,
    this.hint,
    this.stream,
    this.onChanged,
    this.controller,
    this.tipo,
    this.dataSource,
    this.icon
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: stream,
      builder: (context, snapshot) {
        return Container(
          padding: EdgeInsets.zero,
          child: DropdownButtonFormField(
            value: controller.text,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              icon: Icon(icon, color: Colors.blue[900],),
              labelText: labelText,
            ),
            items: dataSource.map<DropdownMenuItem<String>>((item) {
              return DropdownMenuItem(
                value: item['value'],
                child: Text(item['display']),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        );
      }
    );
  }
}