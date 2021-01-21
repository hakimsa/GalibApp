
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';

Future <List<dynamic>> initiate() async {
  // Make API call to Hackernews homepage
  var client = Client();
  Response response = await client.get('https://www.farodevigo.es/suscriptor/');

  // Use html parser
  var document = parse(response.body);
  List<Element> links = document.querySelectorAll(' div.noticia  ');
  List<Map<String, dynamic>> linkMap = [];
  List<Element> images = document.querySelectorAll('div.noticia > div.imagen > a >picture > source ');
  List<Map<String, dynamic>> imageMap = [];
  List<dynamic> milista = [];
  for (var link in links) {
    linkMap.add({
     'title': link.text,




    });

  }
  for (var img in images) {

    imageMap.add({
      "imagen":img.attributes["data-srcset"],
      //'titulo': img.text,


    });
   // milista.add(linkMap);
    var arr = imageMap.toString().split('*w');

    milista.add(imageMap);
   // print("listado :"+milista.length.toString());

    print("listado :"+arr.toString());
  }

  return milista.toList();
}