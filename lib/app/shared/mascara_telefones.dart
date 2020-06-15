
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MafoobaMasked extends TextInputFormatter {
  String maskONE;
  String maskTWO;

  MafoobaMasked({this.maskONE, this.maskTWO}) {
    assert(maskONE != null);
    assert(maskTWO != null);

  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    
    TextEditingValue teste;
    String cod;
    int select;
    if (newValue.text.length > 0) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > maskTWO.length) {
          return oldValue;
        }

        if (newValue.text.length <= maskONE.length && (maskONE[newValue.text.length - 1] != "X") && newValue.text.length != oldValue.text.length) {
          if ((maskONE[newValue.text.length - 1] != "X")) {
            select = 1;
              cod = '${oldValue.text}' + maskONE[newValue.text.length - 1];
              if(maskONE[newValue.text.length] != "X"){
                cod += maskONE[newValue.text.length];
                select += 1;
            }
              cod += '${newValue.text.substring(newValue.text.length - 1)}';
              teste = TextEditingValue(
                text: cod,
                selection: TextSelection.collapsed(
                  offset: newValue.selection.end + select,
                ),
              );
              return teste;
            }
          } 

         else if (newValue.text.length > maskONE.length) {
          String TWO = "";
          if (oldValue.text.length == maskONE.length) {
            newValue.text.runes.forEach((int rune) {
              var character = new String.fromCharCode(rune);

              if (maskTWO[TWO.length ] == ' ') {
                TWO += ' ';
              }
              if (maskTWO[TWO.length ] == '-') {
                TWO += '-';
              }
              if(character != '-')
                TWO = TWO + character;
            });

            return TextEditingValue(
              text: '$TWO',
              selection: TextSelection.collapsed(
                offset: TWO.length,
              ),
            );
          }
        }
      } else if (oldValue.text.length > newValue.text.length) {
        if (oldValue.text.length == (maskTWO.length)) {
          String ONE = "";
          newValue.text.runes.forEach((int rune) {
            var character = new String.fromCharCode(rune);
            if(character != ')' && character != '-' && character != ' ') {
              ONE = ONE + character;
              try {
                if (maskONE[ONE.length] != "X") {
                  ONE = '$ONE' + maskONE[ONE.length];
                }
              }
              catch (Exception) {
              }
            }
          });
          return TextEditingValue(
            text: '$ONE',
            selection: TextSelection.collapsed(
              offset: ONE.length,
            ),
          );
        }
      }
    }
    return newValue;
  }
}