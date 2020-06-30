
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'FirebaseChatroom.dart';
import 'NoticiasF.dart';
class ProfileFivePage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    final Color color1 = Colors.lightBlue;
    final Color color2 = Colors.lightBlueAccent;

    return Scaffold(
      body: Stack(
        children: <Widget>[
Container(
      child: SingleChildScrollView(
        child: Container(
            height: 360,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0), bottomRight: Radius.circular(50.0)),
                gradient: LinearGradient(
                    colors: [color1,color2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight
                )
            ),
          ),
        ),

      ),


          Container(
            margin: const EdgeInsets.only(top: 70),
            child: Column(
              children: <Widget>[
                Text("Developer MultiPlataforma", style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontStyle: FontStyle.italic
                ),),
                SizedBox(height: 20.0),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: double.infinity,
                        margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(30.0),
                            /*child: Image.asset("assets/images/logo.png",fit: BoxFit.cover,)*/),
                      ),
                      Container(

                        alignment: Alignment.topCenter,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0)
                          ),
                          child: CircleAvatar(
                            maxRadius: 40,
                            minRadius: 40,
                            backgroundImage: NetworkImage("http://www.graficaszamart.com/imprenta/wp-content/uploads/2015/08/Foto-perfil.jpg"),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                Text("- Hakim Samouh -", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0
                ),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.location_on, size: 16.0, color: Colors.grey,),
                    Text("Pontevedra, Vigo , España", style: TextStyle(color: Colors.grey.shade600),)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.email, size: 16.0, color: Colors.orangeAccent,),
                    Text("Samouh591@gmail.com", style: TextStyle(color: Colors.grey.shade600),)
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      color: Colors.grey,
                      icon: Icon(FontAwesomeIcons.instagram),
                      onPressed:() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => noticia()),
                        );
                      },
                    ),
                    IconButton(
                      color: Colors.grey,
                      icon: Icon(FontAwesomeIcons.facebookF),
                      onPressed: (){},
                    ),
                    IconButton(
                      color: Colors.grey.shade600,
                      icon: Icon(FontAwesomeIcons.twitter),
                      onPressed: (){},
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                        margin: const EdgeInsets.only(top: 30 ,left: 20.0, right: 20.0,bottom: 20.0),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [color1,color2],
                            ),
                            borderRadius: BorderRadius.circular(30.0)
                        ),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              color: Colors.white,
                              icon: Icon(FontAwesomeIcons.user),
                              onPressed: ()
                              {print("holaksj");},
                            ),
                            IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.location_on),
                              onPressed: (){},
                            ),
                            Spacer(),
                            IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.add),
                              onPressed: (){},
                            ),
                            IconButton(
                              icon: Icon(Icons.message),
                              color: Colors.white,
                              onPressed: (){  Navigator.push(context,  MaterialPageRoute(
                                  builder: (context) => FirebaseChatroom()),
                              );},
                            ),
                          ],
                        ),
                      ),

                      Center(
                        child: FloatingActionButton(
                          child: Icon(Icons.favorite, color: Colors.pink,),
                          backgroundColor: Colors.white,
                          onPressed: (){    Navigator.pop(context);
                         ;},
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: (){  },
              ),
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: (){},
              ),
            ],
          ),
        ],
      ),
    );
  }
}