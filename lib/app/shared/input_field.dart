import 'package:flutter/material.dart';
import 'package:mask_shifter/mask_shifter.dart';

class InputField extends StatelessWidget {

  final IconData icon;
  final String hint;
  final bool obscuro;
  final Stream<String> stream;
  final Function(String) onChanged;
  final TextEditingController controller;
  final TextInputType tipo;

  const InputField({Key key, this.icon, this.hint, this.obscuro, this.stream, this.onChanged , this.controller, this.tipo}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: stream,
      builder: (context, snapshot) {
        return TextFormField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            icon: Icon(icon, color: Colors.blue[900],),
            labelText: hint,
          ),
          obscureText: obscuro,
          keyboardType: tipo,
          inputFormatters: [
            hint == 'Contato' ? MaskedTextInputFormatterShifter(
              maskONE: '(XX) XXXX-XXXX',
              maskTWO: '(XX)X-XXX-XXXX',
            ) : MaskedTextInputFormatterShifter(
              maskONE: '',
              maskTWO: ''
            ),
          ],
        );
      }
    );
  }
}
