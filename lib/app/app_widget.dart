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
          caption: TextStyle(fontSize: 18.0, fontFamily: 'snap', color: Colors.green[800]),
          bodyText1: TextStyle(fontSize: 18.0, fontFamily: 'snap', color: Colors.green[800]),
          bodyText2: TextStyle(fontSize: 18.0, fontFamily: 'snap', color: Colors.blue[900]),
          headline1: TextStyle(fontSize: 18.0, fontFamily: 'snap', color: Colors.green[800]),
          overline: TextStyle(fontSize: 8.0, fontFamily: 'snap', color: Colors.green[800]),
          subtitle1: TextStyle(fontSize: 18.0, fontFamily: 'snap', color: Colors.blue[900]),
          subtitle2: TextStyle(fontSize: 8.0, fontFamily: 'snap', color: Colors.green[800]),
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
