
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:galibebe/routas/Routas.dart';

void main() async => (runApp(MyApp()));
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
debugShowCheckedModeBanner: false,
        initialRoute: 'homePage',
        routes: getApplicationRoutes(),
        theme: ThemeData(
          // Define the default brightness and colors.
         // brightness: Brightness.dark,
         primaryColor: Colors.cyan,


          // Define the default font family.
          fontFamily: 'Georgia',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        )
    );
  }
}

