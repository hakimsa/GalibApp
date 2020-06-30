
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:galibebe/models/Ayuda.dart';
import 'package:galibebe/service/ProviderAyuda/ProviderAyuda.dart';
import 'package:galibebe/src/vistas/ListadoAyudas.dart';

class DataSearch extends SearchDelegate {
  String seleccion = '';
  ProviderAyuda providerAyuda=new ProviderAyuda();
  List<Ayuda> ayudas;
 // final peliculasProvider = new Provider();


  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar


    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,

      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias que aparecen cuando la persona escribe
    if (query.isEmpty) {
      return Container();
    }

    return StreamBuilder<QuerySnapshot>(
     stream:providerAyuda.fetchAyudasStream(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
   ayudas =snapshot.data.documents.map((doc) => Ayuda.fromMap(doc.data, doc.documentID)).toList();
   final listaSugerida = ( query.isEmpty )
       ? ayudas
       : ayudas.where(
           (p)=> p.titulo.toLowerCase().startsWith(query.toLowerCase())
   ).toList();
          return ListView.builder(
            itemCount: listaSugerida.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(listaSugerida[index].image),
                  placeholder: AssetImage('assets/images/loader.gif'),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(listaSugerida[index].titulo.toString()),
                subtitle: Text(listaSugerida[index].descripcion),
                onTap: () {
                  close(context, null);
                  // pelicula.uniqueId = '';
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailPage(post: listaSugerida[index],
                      )));
                },
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }



}
