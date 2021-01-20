import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:galibebe/service/ServiceAuth.dart';
import 'FirebaseChatroom.dart';
import 'ListadoAyudas.dart';
import 'NoticiasF.dart';
import 'acerca.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController controladorEmail = TextEditingController();
  TextEditingController controladorPwd = TextEditingController();
   FirebaseUser _user;
   FirebaseAuth _auth;
  Auth aut=new Auth.init();


  @override
  void initState() {

    super.initState();
    kFirebaseAuth.currentUser().then(
          (user) => setState(() => this._auth = _auth),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: contenido(context),

      backgroundColor:Colors.blue.shade200,
    );
  }

  contenido(BuildContext context) {
    return ListView(
      children: <Widget>[
        SizedBox(height: 60,),
        _LoginForm(context),

      ],
    );
  }



  Container _LoginForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Stack(
        children: <Widget>[

          ClipPath(

            child: Container(
                //height: 400,
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
                              Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regExp=new RegExp(pattern);
                              if (value.isEmpty) {
                                return 'Por favor indica tu email';
                              }else if (regExp.hasMatch(value)){
                                return null;
                              }
                              return 'Email incorrecto o no existe ';
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
                              }else if ((value.length < 6) || value.isEmpty){
                                return 'La contraseña debe tener mas de 6 caracteres ';
                              }
                              return null;
                            },
                            obscureText: true,
                            controller: controladorPwd,
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

                      
                      SizedBox(height: 10.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        FlatButton(onPressed: (){
                          Navigator.pushNamed(context, "SignupPage");
                        }, child: Text("¿Registrate? ",style:TextStyle(color:Colors.cyan))
                        ),

                      ],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FlatButton(onPressed: (){
                           //
                            // Navigator.pushNamed(context, "SignupPage");
                          }, child: Text("¿He olvidado mi contraseña? ",style:TextStyle(color:Colors.cyan))
                          ),

                        ],),
                      SignInButtonBuilder(
                          backgroundColor: Colors.cyan,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0)),
                          text: 'Sign in with Email',
                          icon: Icons.email,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {

                              if(_user==null) {
                                _SignEmailPassword(_user);
                              }else _alertaEmail();
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                            }}),
                      SignInButton(
                        Buttons.Google,
                        text: "Sign up with Google",
                        onPressed: () {

                          _singUserGoogle(_auth);

                        },
                      ),
                      SizedBox(height: 2,),




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
                backgroundColor: Colors.cyan,
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/logo.png"),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  Future<FirebaseUser> _SignEmailPassword(FirebaseUser CurUserEmailPss) async {
    final CurUserEmailPss = this._user ??
        await kFirebaseAuth.signInWithEmailAndPassword(
            email: controladorEmail.text, password: controladorPwd.text);

    if (CurUserEmailPss != null){

      _showPerfilUser(CurUserEmailPss);
    }

  }

  _showPerfilUser(FirebaseUser curUserEmailPss) async {
    final curUserEmailPss = this._user ?? await kFirebaseAuth.currentUser();

    String background ;
    if (curUserEmailPss.photoUrl == null) {
      background =
          "https://pngimage.net/wp-content/uploads/2018/06/perfil-icono-png-3.png";
    } else {
      background = curUserEmailPss.photoUrl;
    }
    if (curUserEmailPss == null) {
      return CircularProgressIndicator();
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => Scaffold(
            drawer: Menu(context, curUserEmailPss),
            appBar: AppBar(
              title: Text("Welcome " + curUserEmailPss.email.substring(0, 4),style: TextStyle(color: Colors.white),),
              //backgroundColor: Color.fromRGBO(77, 77, 77, 0.85),
              actions: [
                Container(
                  margin: EdgeInsets.all(10.2),
                  child: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Text(curUserEmailPss.email.substring(0, 4)),
                      backgroundImage: NetworkImage(background)),
                )
              ],
            ),
            body: Stack(children: [
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(60),
                height: 100,
                width: 100,
                transform: Matrix4.rotationZ(044),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.45),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.blue,blurRadius: 3.8
                      )
                    ],
                    borderRadius: BorderRadius.circular(100)),
              ),
          Positioned(
            left: 100,
            bottom: 50,
            child:     Container(
              height: 100,
              width: 100,
              transform: Matrix4.rotationZ(874),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.45),
                 boxShadow: <BoxShadow>[
                   BoxShadow(
                     color: Colors.lightBlueAccent,
                     blurRadius: 2.65
                   )
                 ],
                  borderRadius: BorderRadius.circular(100)),
            ),

          ),
              Positioned(
                right: 110,
                bottom: 150,
                child: Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(10),
                  width: 120,
                  height: 120,
                  transform: Matrix4.rotationZ(774),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(124, 254, 452, 0.32),
                      borderRadius: BorderRadius.circular(100)),
                ),
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                        backgroundColor: Colors.green,
                        backgroundImage:
                        AssetImage("assets/images/logo.png")
                    ),
                  ]),
      Positioned(
        right: 12.0,
        top: 240,
        child:Container(

          width: 80,
          height: 80,
          clipBehavior: Clip.antiAlias,
          transform: Matrix4.rotationZ(264),
          decoration: BoxDecoration(
              color: Colors.cyan.shade600,
              borderRadius: BorderRadius.all(Radius.circular(100))),
        ) ,
      ),


              Container(
                margin: EdgeInsets.only(top: 50),


                child: GridView.count(
                  crossAxisCount: 3,
                  children: [

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromRGBO(77, 77, 77, 0.34),
                      ),
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(2),
                      width: 90,

                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.3)),
                           //color: Color.fromRGBO(77, 77, 77, 0.86),
                          color: Colors.white,
                          elevation: 20,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                            Text("Chat",style: TextStyle(color: Colors.blue),),
                              IconButton(
                                icon: Image.network("http://icons.iconarchive.com/icons/graphicloads/100-flat-2/128/chat-2-icon.png"),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FirebaseChatroom()),
                                  );

                                },
                              ),

                            ],
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromRGBO(77, 77, 77, 0.34),

                      ),
                      width: 90,
                      height: 100,
                      child: Card(
                        //  color: Color.fromRGBO(77, 77, 77, 0.86),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.3)),
                          color: Colors.white,
                          elevation: 20,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                            Text("Ayudas",style: TextStyle(color: Colors.blue),),
                              IconButton(
                                icon: Image.network("http://icons.iconarchive.com/icons/dapino/baby-boy/128/baby-idea-icon.png"),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ListadoAyudas()),
                                  );
                                },
                              ),

                            ],
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromRGBO(77, 77, 77, 0.34),
                      ),

                      child: Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.3)),
                          // color:
                          //   Color.fromRGBO(77, 77, 77, 0.86),
                          color: Colors.white,
                          elevation: 20,
                          margin: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Text("Noticias",style: TextStyle(color: Colors.blue),),
                              IconButton(
                                icon: Image.network("https://icons.iconarchive.com/icons/musett/coffee-shop/128/Newspaper-icon.png",width: 200,),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => noticia()),
                                  );
                                },
                              ),

                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ]))));
  }

  Menu(BuildContext context, FirebaseUser curUserEmailPss) {
    return Drawer(
      child: DrawerHeader(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(curUserEmailPss.photoUrl ==
                      null
                      ? "http://icons.iconarchive.com/icons/everaldo/crystal-clear/128/App-login-manager-icon.png"
                      : curUserEmailPss.photoUrl),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [Text(curUserEmailPss.email)],
                )
              ],
            ),
            Container(
                height: 250,
                width: 100,
                transform: Matrix4.rotationZ(77),
                decoration: BoxDecoration(
                  //    color: Color.fromRGBO(58, 77, 887, 0.68),
                    color: Colors.cyan,
                    borderRadius: BorderRadius.circular(80)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    child: Text(curUserEmailPss.email.substring(0,3)),
                  ),
                ],
              )

            ),


            Divider(
              color: Colors.black54,
            ),
            Column(
              children: [
                ListTile(
                  title: Text("Ajustes"),
                  trailing: Icon(Icons.settings, color: Colors.lightBlueAccent),
                  onTap: () {
                    print("ajustes");
                  },
                ),
                ListTile(
                  title: Text(
                    "Acerca",
                  ),
                  trailing:
                      Icon(Icons.help_outline, color: Colors.lightBlueAccent),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => acerca()),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    "Salir",
                  ),
                  trailing: Icon(Icons.cancel, color: Colors.lightBlueAccent),
                  onTap: () {

                    _alerta(context);


                  },
                ),
                SizedBox(
                  height: 40,

                ),
               CircleAvatar(
                 backgroundImage:  AssetImage(
                   "assets/images/logo.png",
                 ),
               )
              ],
            ),
          ],
        ),
      )),
    );
  }

  Future<LoginPage> _signOut() async {

    await kFirebaseAuth.signOut();
      this._user=null;

  }

  void _singUserGoogle(FirebaseAuth usuarioGoogle) async {
    final usuarioGoogle = this._user ?? await kFirebaseAuth.currentUser();
    final googleUser = await kGoogleSignIn.signIn();
    final googleAuth = await googleUser.authentication;
    final Credential credential = GoogleSignInAuthentication.Credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Note: user.providerData[0].photoUrl == googleUser.photoUrl.
    _user = await kFirebaseAuth.signInWithCredential(credential);
    if (_user != null) {
      _showPerfilUser(usuarioGoogle);
    }
  }



  _alerta(BuildContext context) {


    return showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Salir"+"\n",style: TextStyle(
              fontSize: 1952
              ,

            ),),
            content: Text("¿ Estas seguro de cerrar sesion?"),
            actions: [
              RaisedButton(onPressed: (){
                setState(() {

                  _signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );

                });

              }
                ,elevation: 20,


                child:Text("Si",style: TextStyle(color: Colors.red),) ,
              ),
              RaisedButton(onPressed: (){
                setState(() {


                    Navigator.pop(context);

                });

              }

                ,elevation: 20,
                color: Colors.blueGrey,
                child:Text("No") ,
              )
            ],

          );
        }

    );
  }



  _alertaEmail() async{
    showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title: Icon(Icons.warning,color: Colors.redAccent,),
            content: Text(controladorEmail.text
            + " o Contraseña no es Correcto o no existe verificalo por favor "),
            actions: [
              RaisedButton(onPressed: (){
                setState(() {
                  Navigator.pop(context);
                });
              }
                ,elevation: 20,
                color: Colors.blueGrey,
                child:Text("ok") ,
              )
            ],

          );
        }

    );

  }

  /* _validaremail(String value) {


     Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
     RegExp regExp=new RegExp(pattern);

    if (value.isEmpty) {
      return 'Por favor indica tu email';
    }else if (regExp.hasMatch(value)){
      return 'Email incorrecto o no existe ';
    }
    return null;

  }*/



}
