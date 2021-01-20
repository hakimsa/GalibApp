


import 'package:flutter/material.dart';
import 'package:galibebe/src/vistas/ChatContact.dart';
import 'package:galibebe/src/vistas/FirebaseChatroom.dart';
import 'package:galibebe/src/vistas/ListadoAyudas.dart';
import 'package:galibebe/src/vistas/Mulitmedia.dart';
import 'package:galibebe/src/vistas/NoticiasF.dart';
import 'package:galibebe/src/vistas/SignupPage.dart';
import 'package:galibebe/src/vistas/login_page.dart';

Map<String,WidgetBuilder>getApplicationRoutes() {
  return <String, WidgetBuilder>{
    'homePage': (BuildContext context) => LoginPage(),
    "chat": (BuildContext context) => FirebaseChatroom(),
    "SignupPage": (BuildContext context) => SignupPage(),
    "noticias": (BuildContext context) => noticia(),
    "ayudas":(BuildContext context)=>ListadoAyudas(),
    Multi_Video.routeName: (BuildContext context) => Multi_Video(),
    ChatTwoPage.routeName:(BuildContext context)=>ChatTwoPage()
  };
}