import 'package:flutter/material.dart';

Widget FundoGradiente() => Container(
  decoration: BoxDecoration(
      gradient: LinearGradient(
          colors: [
            Colors.green[500],
            Colors.white,
            //Color.fromARGB(-43, 152, 249, 200),
            //Color.fromARGB(-29, 144, 240, 244),
            //Color.fromARGB(-14, 194, 238, 240),
            //Colors.white
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter
      )
  ),
);
