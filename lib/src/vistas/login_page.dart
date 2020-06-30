import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:galibebe/service/ServiceAuth.dart';
import 'FirebaseChatroom.dart';
import 'ListadoAyudas.dart';
import 'Mulitmedia.dart';
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


  @override
  void initState() {

    super.initState();
    kFirebaseAuth.currentUser().then(
          (user) => setState(() => this._auth = user as FirebaseAuth),
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

        _buildLoginForm(context),

      ],
    );
  }

  _buildLoginForm(BuildContext context) {
    return Center(
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
              color: Color.fromRGBO(77, 77, 77, 0.65)
          ),
          padding: EdgeInsets.all(20.0),
          margin: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Stack(
              children: <Widget>[
                ClipPath(
                  clipper: RoundedDiagonalPathClipper(),
                  child: Container(
                    height: 500,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 90.0,
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child:TextFormField(
                              // Validacion del campo EditText email.
                              validator: (value) {

                                if (value.isEmpty) {
                                  return 'Por favor indica tu email';
                                }else if ((value.toString().contains("@")==false) ||( value.isEmpty) || (value.toString().contains(".")==false)){
                                  return 'Email incorrecto o no existe ';
                                }
                                return null;
                              },
                              style: TextStyle(color: Colors.black87),
                              controller: controladorEmail,
                              keyboardType:TextInputType.emailAddress,
                              decoration: InputDecoration(

                                  hintText: "Email address",
                                  hintStyle: TextStyle(color: Colors.blue.shade200),
                                  border: InputBorder.none,
                                  icon: Icon(
                                    Icons.email,
                                    color: Colors.blue,
                                  )),
                            )),
                        Container(
                          child: Divider(
                            color: Colors.blue.shade400,
                          ),
                          padding:
                          EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextFormField(
                              // Validacion del campo EditText contraseña.
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Por favor indica tu contraseña';
                                }else if ((value.length < 5) || value.isEmpty){
                                  return 'la contraseña debe tener mas de 5 caracteres ';
                                }
                                return null;
                              },
                              obscureText: true,
                              controller: controladorPwd,
                              style: TextStyle(color: Colors.black87),
                              decoration: InputDecoration(
                                  hintText: "Contraseña",
                                  hintStyle: TextStyle(color: Colors.blue.shade200),
                                  border: InputBorder.none,
                                  icon: Icon(
                                    Icons.lock,
                                    color: Colors.blue,
                                  )),
                            )),
                        Container(
                          child: Divider(
                            color: Colors.blue.shade400,
                          ),
                          padding:
                          EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.only(right: 20.0),
                                child: FlatButton(onPressed: (){}, child: Text("¿Ha olvidado su contraseña? ",style:TextStyle(color:Colors.cyan))))
                          ],
                        ),

                     Row(children: [
                       FlatButton(onPressed: (){
                         Navigator.pushNamed(context, "SignupPage");
                       }, child: Text("¿Registrate? ",style:TextStyle(color:Colors.cyan))
                       )],),

                     SignInButtonBuilder(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0)),
                          text: 'Sign in with Email',
                          icon: Icons.email,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {

                              if(_user!=null) {
                                _SignEmailPassword(_user);
                              }else _alertaEmail();
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                            }


                          },
                          backgroundColor: Colors.blueGrey[700],
                        ),

                        SignInButton(
                          Buttons.Google,
                          text: "Sign up with Google",
                          onPressed: () {
                            _singUserGoogle(_auth);
                          },
                        ),


                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40.0,

                      backgroundColor: Color.fromRGBO(77, 77, 77, 0.58),

                      child: CircleAvatar(

                        backgroundImage: AssetImage("assets/images/logo.png"),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          )
      ) ,
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
                margin: EdgeInsets.all(10),
                height: 250,
                transform: Matrix4.rotationZ(094),
                decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(20)),
              ),
              Container(
                height: 250,
                transform: Matrix4.rotationZ(874),
                decoration: BoxDecoration(
                //    color: Color.fromRGBO(58, 77, 887, 0.68),
                  color: Colors.cyan,
                    borderRadius: BorderRadius.circular(20)),
              ),
              Positioned(
                right: 110,
                bottom: 150,
                child: Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(10),
                  width: 120,
                  height: 150,
                  transform: Matrix4.rotationZ(774),
                  decoration: BoxDecoration(
                      color: Colors.blue.shade700,
                      borderRadius: BorderRadius.circular(20)),
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
        right: 2.0,
        top: 240,
        child:Container(

          width: 120,
          height: 80,
          clipBehavior: Clip.antiAlias,
          transform: Matrix4.rotationZ(364),
          decoration: BoxDecoration(
              color: Colors.cyan.shade700,
              borderRadius: BorderRadius.all(Radius.elliptical(15,8))),
        ) ,
      ),


              Container(
                width: double.infinity,
                height: 620,
                child: GridView.count(
                  crossAxisCount: 2,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromRGBO(77, 77, 77, 0.34),
                      ),
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(10),
                      width: 80,
                      height: 80,
                      child: Card(
                          // color: Color.fromRGBO(77, 77, 77, 0.86),
                          color: Colors.white,
                          elevation: 20,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
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
                              Text(
                                "Chat",
                                style:
                                    TextStyle(color: Colors.blueGrey, fontSize: 20,),
                              )
                            ],
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromRGBO(77, 77, 77, 0.34),

                      ),
                      width: 80,
                      height: 80,
                      child: Card(
                        //  color: Color.fromRGBO(77, 77, 77, 0.86),
                          color: Colors.white,
                          elevation: 20,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
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
                              Text(
                                "Auydas",
                                style: TextStyle(
                                    color: Colors.blueGrey, fontSize: 20),
                              )
                            ],
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromRGBO(77, 77, 77, 0.34),
                      ),
                      width: 80,
                      height: 80,
                      child: Card(
                          // color:
                          //   Color.fromRGBO(77, 77, 77, 0.86),
                          color: Colors.white,
                          elevation: 20,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Image.network("http://icons.iconarchive.com/icons/paomedia/small-n-flat/128/news-icon.png"),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => noticia()),
                                  );
                                },
                              ),
                              Text(
                                "Noticias",
                                style: TextStyle(
                                    color: Colors.blueGrey, fontSize: 20),
                              )
                            ],
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromRGBO(77, 77, 77, 0.34),

                      ),
                      width: 80,
                      height: 80,
                      child: Card(
                        //  color: Color.fromRGBO(77, 77, 77, 0.86),
                          color: Colors.white,
                          elevation: 20,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Image.network("http://icons.iconarchive.com/icons/designbolts/free-multimedia/128/Film-icon.png"),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>    Video_show()),
                                  );
                                },
                              ),
                              Text(
                                "Videos",
                                style: TextStyle(
                                    color: Colors.blueGrey, fontSize: 20),
                              )
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
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(80)),

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
    _user=null;
    await kFirebaseAuth.signOut();
  }

  void _singUserGoogle(FirebaseAuth usuarioGoogle) async {
    final usuarioGoogle = this._user ?? await kFirebaseAuth.currentUser();
    final googleUser = await kGoogleSignIn.signIn();
    final googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
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
            title: Text("  quieres salir ?"+"\n"+_user.email,style: TextStyle(
              fontSize: 14,

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



}
