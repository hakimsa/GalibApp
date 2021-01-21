import 'package:flutter/material.dart';



_alerta(BuildContext context){

  return showDialog(context: context,
  builder: (context){
    return AlertDialog(
      title: Text(" Salir "),
      content: Text(" Estas seguro de cerrar sesion"),
      actions: [
        RaisedButton(onPressed: (){}
        ,elevation: 20,
         child:Text("Si") ,
        )
      ],

    );
  }

  );

}

