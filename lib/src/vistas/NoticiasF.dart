import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'WebViewContainer.dart';

class noticia extends StatelessWidget {
  //final Function siguientepaina;
  final _pageController =
      new PageController(initialPage: 1, viewportFraction: 0.3);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [

          SizedBox(
            height: 56,
          ),
          buttonBack(context),
          getNewNoticias(context),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Text("Todas las noticias"),
            ],
          ),
          getAllNoticias(context)
        ],
      ),
    ));
  }

  Allnoticias(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("Noticias").snapshots(),
        builder: (context, snap) {
          //compruebo los datos si son nullos
          if (snap.data == null)
            return Center(
              child: CircularProgressIndicator(),
            );
          navigateDatail(DocumentSnapshot post) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailPage(
                          post: post,
                        )));
          }

          return PageView.builder(
              controller: _pageController,
              itemBuilder: (BuildContext context, int index) {
                Firestore.instance.collection("Noticias").snapshots();
                _pageController.addListener(() {
                  if (_pageController.position.pixels >=
                      _pageController.position.maxScrollExtent)
                    print("seginte");
                  //siguientepaina();
                });

                final card = Card(
                    margin: EdgeInsets.all(5),
                    elevation: 10,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.3)),
                    child: Hero(
                      tag: snap.data.documents[index]["foto"],
                      child: Container(
                        width: 180,
                        color: Colors.green,
                        child: FadeInImage(
                          placeholder: AssetImage('assets/images/loader.gif'),
                          image:
                              NetworkImage(snap.data.documents[index]["foto"]),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ));

                return GestureDetector(
                    child: card,
                    onTap: () {
                      navigateDatail(snap.data.documents[index]);
                    });
              },
              itemCount: snap.data.documents.length,
              scrollDirection: Axis.horizontal);
        });
  }

  getAllNoticias(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.grey,
          height: 100,
          width: double.infinity,
          child: Allnoticias(context),
        )
      ],
    );
  }

  buttonBack(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.lightBlueAccent,
                size: 37,
              ),
            )
          ],
        ),
      ],
    );
  }
}

@override
Widget getNewNoticias(BuildContext context) {
  return _tajetasNoticias(context);
}

Widget _tajetasNoticias(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection("Noticias").snapshots(),
    builder: (context, snap) {
      //compruebo los datos si son nullos
      if (snap.data == null)
        return Center(
          child: CircularProgressIndicator(),
        );
      navigateDatail(DocumentSnapshot post) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPage(
                      post: post,
                    )));
      }

      return new SingleChildScrollView(
          child: Column(children: [
        SizedBox(
          height: 10,
        ),
        Swiper(
          itemCount: snap.data.documents.length,
          layout: SwiperLayout.STACK,
          itemHeight: 360,
          itemWidth: 219,
          itemBuilder: (BuildContext context, int index) {
            return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: FadeInImage(
                        placeholder: AssetImage('assets/images/loader.gif'),
                        image: NetworkImage(
                            snap.data.documents[index].data["foto"]),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        snap.data.documents[index].data["titulo"],
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    )
                  ],
                ));
          },
          autoplay: true,

          scrollDirection: Axis.horizontal,
          onTap: (index) {
            navigateDatail(snap.data.documents[index]);
          },
          //pagination: new SwiperPagination(alignment: Alignment.bottomCenter),
          //   control: new SwiperControl(),
        ),
      ]));
    },
  );
}

//bundel de detalles de cada ayuda
class DetailPage extends StatefulWidget {
  final DocumentSnapshot post;

  DetailPage({this.post});

  DetailPageState createState() => DetailPageState();
}

class DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: 250.0,
          flexibleSpace: FlexibleSpaceBar(
              background: FadeInImage(
            placeholder: AssetImage("assets/images/original.gif"),
            image: NetworkImage(widget.post.data["foto"]),
            fit: BoxFit.cover,
          )),
          title: Text(widget.post.data["titulo"]),
        ),
        SliverList(delegate: SliverChildListDelegate(Contenido())),
      ],
    )

        );

  }

  void _handleURLButtonPress(BuildContext context, String url) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url)));
  }

  List<Widget> Contenido() {
    return [
      Column(children: [
        SizedBox(
          height: 35,
        ),
        Card(
            elevation: 20,
            shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(2.0)),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: <Widget>[
                Text(
                  widget.post.data["titulo"],
                  style: new TextStyle(
                    letterSpacing: 02.3,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            )
        ),
        SizedBox(height: 20,),
        descripcion(),
      ])
    ];
  }

  descripcion() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Hero(
          tag: widget.post.data["foto"],
          child: Card(
            elevation: 10,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.3)),
            child: Row(
             crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(child: Image.network(widget.post.data["foto"]),width: 90,)
              ],
            ),
          ),
        ),


        SizedBox(width: 5,),

        Flexible(
          flex: 9,
          child: Column(
            children: [
              Row(
                children: [


                ],
              ),
              Text(widget.post.data["descripcion"]),
              OutlineButton.icon(
                label: Text("Ver mas"),
                icon: Icon(Icons.remove_red_eye,color: Colors.blueAccent,),
                onPressed: () {
                  _handleURLButtonPress(
                      context, widget.post.data["enlace"].toString());
                },
              ),

            ],
          ),
        )
      ],
    );
  }
}
