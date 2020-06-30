import 'package:flutter/material.dart';
import 'package:galibebe/service/ServiceAuth.dart';

import 'login_page.dart';

class SignupPage extends StatelessWidget {
  TextEditingController controladorEmail = TextEditingController();
  TextEditingController controladorPwd1 = TextEditingController();
  TextEditingController controladorPwd2 = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  Widget _buildPageContent(BuildContext context) {
    return Container(
      color: Colors.blue.shade100,
      child: ListView(
        children: <Widget>[
          SizedBox(height: 30.0,),
         // CircleAvatar(child: Image.asset("assets/images/logo.png"),
           // maxRadius: 50, backgroundColor: Colors.transparent,),
          SizedBox(height: 20.0,),
          _buildLoginForm(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              FloatingActionButton(
                mini: true,
                onPressed: (){
                  Navigator.pop(context);
                },
                backgroundColor: Colors.lightBlueAccent,
                child: Icon(Icons.arrow_back),
              )
            ],
          )
        ],
      ),
    );
  }

  Container _buildLoginForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Stack(
        children: <Widget>[
          ClipPath(

            child: Container(
              height: 400,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                color: Colors.white,
              ),
              child:Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 90.0,),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          // Validacion del campo EditText email.
                          validator: (value) {

                            if (value.isEmpty) {
                              return 'Por favor indica tu email';
                            }else if ((value.toString().contains("@")==false) ||( value.isEmpty) || (value.toString().contains(".")==false)){
                              return 'Email incorrecto o no existe ';
                            }
                            return null;
                          },
                          controller: controladorEmail,
                          style: TextStyle(color: Colors.blue),
                          decoration: InputDecoration(
                              hintText: "Email address",
                              hintStyle: TextStyle(color: Colors.blue.shade200),
                              border: InputBorder.none,
                              icon: Icon(Icons.email, color: Colors.blue,)
                          ),
                        )
                    ),
                    Container(child: Divider(color: Colors.blue.shade400,),
                      padding: EdgeInsets.only(left: 20.0,right: 20.0, bottom: 10.0),),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          // Validacion del campo EditText contraseña.
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Por favor indica tu contraseña';
                            }else if ((value.length < 5) || value.isEmpty){
                              return 'la contraseña debe tener mas de 5 caracteres ';
                            }else if ((controladorPwd1.text!=controladorPwd2.text) || value.isEmpty){
                              return 'la contraseña no coincide ';
                     }

                            return null;
                          },
                          obscureText: true,
                          controller: controladorPwd1,
                          style: TextStyle(color: Colors.blue),
                          decoration: InputDecoration(
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.blue.shade200),
                              border: InputBorder.none,
                              icon: Icon(Icons.lock, color: Colors.blue,)
                          ),
                        )
                    ),
                    Container(child: Divider(color: Colors.blue.shade400,), padding: EdgeInsets.only(left: 20.0,right: 20.0, bottom: 10.0),),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          // Validacion del campo EditText contraseña.
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Por favor indica tu contraseña';
                            }else if ((value.length < 5) || value.isEmpty){
                              return 'la contraseña debe tener mas de 5 caracteres ';
                            }else if ((controladorPwd1.text!=controladorPwd2.text) || value.isEmpty){
                              return 'la contraseña no coincide ';
                            }

                            return null;
                          },
                          obscureText: true,
                          controller: controladorPwd2,
                          style: TextStyle(color: Colors.blue),
                          decoration: InputDecoration(
                              hintText: "Confirm password",
                              hintStyle: TextStyle(color: Colors.blue.shade200),
                              border: InputBorder.none,
                              icon: Icon(Icons.lock, color: Colors.blue,)
                          ),
                        )
                    ),
                    Container(child: Divider(color: Colors.blue.shade400,), padding: EdgeInsets.only(left: 20.0,right: 20.0, bottom: 10.0),),
                    SizedBox(height: 10.0,),

                  ],
                ),

              )




            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.blue.shade600,
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/logo.png"),
                ),
              ),
            ],
          ),
          Container(
            height: 420,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                onPressed: (){
    if (_formKey.currentState.validate()) {
      kFirebaseAuth.createUserWithEmailAndPassword(
          email: controladorEmail.text, password: controladorPwd1.text);

      _alerta(context);
    }


                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                child: Text("Sign Up", style: TextStyle(color: Colors.white70)),
                color: Colors.blue,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageContent(context),
    );
  }
  _alerta(BuildContext context) {

    return showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title: Text(" El Usuario?"+"\n"+controladorEmail.text,style: TextStyle(
              fontSize: 14,

            ),),
            content: Text("¿ Ha registrado correctamente?"),
            actions: [
              RaisedButton(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );



              }
                ,elevation: 20,


                child:Text("ok",style: TextStyle(color: Colors.red),) ,
          )]);

        }

    );
  }
}

