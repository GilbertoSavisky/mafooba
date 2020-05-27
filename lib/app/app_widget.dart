import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mafooba/app/modules/home/home_module.dart';

class AppWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.red[800],
        accentColor: Colors.green, //botão
        appBarTheme: AppBarTheme(color: Colors.green),

        // Define the default font family.
        fontFamily: 'snap',
        hintColor: Colors.black, //labelText
        indicatorColor: Colors.teal,

        //buttonColor: Colors.green,


        textTheme: TextTheme(
          //headline: TextStyle(fontSize: 60.0, fontFamily: 'snap', color: Colors.green[800]),
          title: TextStyle(fontSize: 30.0, fontFamily: 'snap', color: Colors.blue),
          body1: TextStyle(fontSize: 18.0, fontFamily: 'snap', color: Colors.blue[900]), //Text
          caption: TextStyle(fontSize: 30.0, fontFamily: 'snap', color: Colors.green[800]),
          //display1: TextStyle(fontSize: 60.0, fontFamily: 'snap', color: Colors.green[800]),
          subtitle: TextStyle(fontSize: 30.0, fontFamily: 'snap', color: Colors.green[800]),
          subhead: TextStyle(fontSize: 18.0, fontFamily: 'snap', color: Colors.blue[900], ),//Text, TextField(labelText),
          display2: TextStyle(fontSize: 10.0, color: Colors.blue[800], ),
        ),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
      debugShowCheckedModeBanner: false,
      home: HomeModule(),
    );
  }
}
