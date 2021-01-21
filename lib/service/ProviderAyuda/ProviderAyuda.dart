import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:galibebe/Bolcs/Api.dart';
import 'package:galibebe/models/Ayuda.dart';


class ProviderAyuda {
  int poularesPage = 0;
  bool _estaCargando = false;

//Firestore.instance.collection("ayudas").snapshots()
  final _ayudasStreamController = StreamController<List<Ayuda>>.broadcast();

  Function(List<Ayuda>) get ayudasSink =>
      _ayudasStreamController.sink.add;

  Stream<List<Ayuda>> get ayudaStream =>
      _ayudasStreamController.stream;

  void disposeStreams() {
    _ayudasStreamController?.close();
  }

  Future <List<Ayuda>> getAyudas()async  {
    Stream uri = Firestore.instance.collection("ayudas").snapshots();
      final list= _prosecarpeticiones(uri.asyncMap((event) => null));
    return list ; }


  Future <List<Ayuda>> _prosecarpeticiones(var snapshot) async {
    final respuesta = await snapshot.documents;
    final ayudas = new Ayudas.fromJsonList(respuesta);
    return ayudas.items;
  }
  List<Ayuda> ayudas;
  ApiAyudas _api = ApiAyudas("ayudas");
  Future<List<Ayuda>> fetchProducts() async {
    var result = await _api.getDataCollection();
    ayudas = result.documents
        .map((doc) => Ayuda.fromMap(doc.data, doc.documentID))
        .toList();
    return ayudas;
  }

  Stream<QuerySnapshot> fetchAyudasStream() {
    return _api.streamDataCollection();
  }

  Future<Ayuda> getProductById(String id) async {
    var doc = await _api.getDocumentById(id);
    return  Ayuda.fromMap(doc.data, doc.documentID) ;
  }

}