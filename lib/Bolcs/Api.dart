import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:galibebe/models/Ayuda.dart';

class ApiAyudas {

  final Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;

  ApiAyudas( this.path ) {
    ref = _db.collection(path);
  }
  Future<QuerySnapshot> getDataCollection() {
    return ref.getDocuments() ;
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots() ;
  }
  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.document(id).get();
  }

 final StreamController _streamAyudaController = StreamController<List<Ayuda>>.broadcast();
 Function(List<Ayuda>) get ayudasSink => _streamAyudaController.sink.add;
 Stream<List<Ayuda>> get ayudasStream => _streamAyudaController.stream;
 dispose() {
  _streamAyudaController.close();
 }


}