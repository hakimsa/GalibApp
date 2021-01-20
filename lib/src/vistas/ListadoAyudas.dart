import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:galibebe/models/Ayuda.dart';
import 'package:galibebe/search/search_delegate.dart';
import 'package:galibebe/service/ProviderAyuda/ProviderAyuda.dart';
import 'package:galibebe/src/vistas/acerca.dart';
import 'package:google_fonts/google_fonts.dart';

import 'WebViewContainer.dart';
import 'hooks_widget.dart';

class ListadoAyudas extends StatefulWidget  {
  final Function() onPressed;
  final String tooltip;
  final IconData icon;

  ListadoAyudas({this.onPressed, this.tooltip, this.icon});

  _ListadoState  createState()=>_ListadoState();

}

class _ListadoState  extends State <ListadoAyudas>
    with SingleTickerProviderStateMixin {
  List<Ayuda> ayudas;
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;
  int indextitulo=0;

  @override
  initState() {
    _animationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {
          indextitulo=indextitulo;
        });
      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.cyan,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }


  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget add() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: Colors.cyan,
        heroTag: "btnadd",
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(
            builder:(context)=> MyAppconect()
          ));
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget image() {
    return Container(
      child: FloatingActionButton(
        heroTag: "btnimage",
        backgroundColor: Colors.cyan,
        onPressed: (){Navigator.pushNamed(context, "Videos");},
        tooltip: 'Image',
        child: Icon(Icons.videocam),
      ),
    );
  }

  Widget inbox() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: Colors.cyan,
        heroTag: "btnbox",
        onPressed: (){
          Navigator.pushNamed(context, "chat2");
        },
        tooltip: 'Inbox',
        child: Icon(Icons.inbox),
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        heroTag: "btnToggle",
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
      ),

    );

  }


  menuflotante() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 3.0,
            0.0,
          ),
          child: add(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: image(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: inbox(),
        ),
        toggle(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ayudas publicas Galicia", style: GoogleFonts.saira(color: Colors.white),),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch(),
              );
            },
          )
        ],
      ),
      body: Stack(
        children: [
          getContent(context),
         _menuActionButton()

        ],
      ),
    );
  }


  getContent(BuildContext context) {
    ProviderAyuda providerAyuda = new ProviderAyuda();

    return StreamBuilder<QuerySnapshot>(
        stream: providerAyuda.fetchAyudasStream(),
        builder: (context, snap) {
          //compruebo los datos si
          // son nullos

          if (snap.hasData) {

            ayudas = snap.data.documents
                .map((doc) => Ayuda.fromMap(doc.data, doc.documentID))
                .toList();
            navigateDatail(Ayuda post) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DetailPage(
                            post: post,
                          )
                  )
              );
            }


            return Container(

                width: double.infinity,
                child: ListView(
                  children: [
                    SizedBox(height: 20,),
                    Swiper(
                      itemCount: ayudas.length,
                      layout: SwiperLayout.STACK,
                      itemHeight: 370,
                      itemWidth: 241,
                      itemBuilder: (context, index) {

                     //print(indextitulo.toString());

                        return ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              children: [
                                Container(
                                  color: Colors.cyan,
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: FadeInImage(
                                    placeholder: AssetImage(
                                        'assets/images/loader.gif'),
                                    image: NetworkImage(
                                        ayudas[index].image),
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                Container(margin: EdgeInsets.all(20),
                                  alignment:Alignment.bottomCenter,
                                  //padding: EdgeInsets.all(30),
                                  child: _Titulo(index)
                                  
                                ),

                              ],
                            ));
                      },
                      autoplay: true,
                      scrollDirection: Axis.horizontal,
                      onTap: (index) {

                        navigateDatail(ayudas[index]);

                      },
                      pagination: new SwiperPagination(alignment: Alignment.bottomCenter),

                    ),

              //      _Titulo(this.indextitulo)
                  ],


                )

              //  margin: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
            );
          }
          return Center(
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10,),
                Text("Cargando datos ...")
              ],
            ),
          );
        });
  }

  _Titulo(index) {
    return Text(ayudas[index].titulo,style: GoogleFonts.sahitya(fontSize: 20,color: Colors.blue,shadows:<BoxShadow>[ BoxShadow(color: Colors.white,blurRadius: 3.3)]));
}

  _menuActionButton() {
    return  Positioned(
        bottom: 50,
        right: 8,
        child:Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        menuflotante(),
    ],
    ));
  }


}


//bundel de detalles de cada ayuda
class DetailPage extends StatefulWidget {
  final Ayuda post;

  DetailPage({this.post});

  DetailPageState createState() => DetailPageState();
}

class DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.lightBlueAccent,
          title: Text(
            widget.post.titulo,style: TextStyle(color: Colors.white),
          ),


        ),
        body: Center(

          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,

              alignment: AlignmentDirectional(40, 20),

              decoration: BoxDecoration(
                boxShadow: [
                  new BoxShadow(
                    color: Colors.lightBlueAccent,
                    blurRadius: 8.0,
                  ),
                ],
              ),
              child: Card(
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0)),
                color: Colors.white,
                child: Column(children: <Widget>[
                  Text(
                    widget.post.titulo,
                    style: new TextStyle(
                      letterSpacing: 02.3,
                      color: Colors.cyan,

                      //backgroundColor: Colors.lightBlueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Image.network(
                    widget.post.image,
                    width: 580.0,
                    fit: BoxFit.cover,

                  ),



                  Divider(
                    color: Colors.white,
                  ),
                  ListTile(
                    title: Text(
                      "¿Qué es ?",
                      style: new TextStyle(
                          color: Colors.cyan, fontWeight: FontWeight.normal),
                    ),
                    subtitle: (Text( widget.post.descripcion, style: new TextStyle(
                        color: Colors.blueGrey.shade700, fontWeight: FontWeight.normal),
                    )),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  ListTile(
                    title: Text("Cuantia",
                      style: new TextStyle(
                          color: Colors.cyan, fontWeight: FontWeight.normal),
                    ),

                    subtitle: Text(widget.post.cuantia,
                      style: new TextStyle(
                          color: Colors.blueGrey.shade700, fontWeight: FontWeight.normal),
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  ListTile(
                    title: Text(
                      "Requisitos",
                      style: new TextStyle(
                          color: Colors.cyan, fontWeight: FontWeight.normal),
                    ),
                    subtitle: (Text( widget.post.requisitos,style: new TextStyle(
                        color: Colors.blueGrey.shade700, fontWeight: FontWeight.normal),
                    )),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Row(
                    mainAxisAlignment:MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [

                      RaisedButton(
                        elevation: 20,
                        color: Colors.cyan,textColor: Colors.white,
                        onPressed: (){ Navigator.pushNamed(context, "chat");},child: Column(
                        children: [
                          Text("Preguntar al Tribu ",style: new TextStyle(
                              color: Colors.white, fontWeight: FontWeight.normal),
                          ),
                          Icon(Icons.chat)
                        ],
                      ),)
                    ],),

                  ListTile(
                    title: Text(" Ver Mas",
                      style: new TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.normal),
                    ),
                    onTap: ()=>_handleURLButtonPress(context,widget.post.enlace.toString()),
                    leading: Icon(Icons.remove_red_eye,color: Colors.cyan,),
                  ),

                ], crossAxisAlignment: CrossAxisAlignment.center),
              ),

            ),


          ),
        )
    );

  }


  void _handleURLButtonPress(BuildContext context, String url) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url)));
  }
}
