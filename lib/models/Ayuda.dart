
class Ayuda{
   String titulo;
   String  descripcion;
   String enlace ;
   String image;
   String cuantia;
   String requisitos;

   Ayuda(this.titulo, this.descripcion, this.enlace, this.image, this.cuantia,
      this.requisitos);

   Ayuda.fromJsonMap( Map<String, dynamic> json ) {

      titulo               = json['titulo'];
      descripcion         = json['descripcion'];
      enlace              = json['enlace'];
      image               = json['image'] ;
      cuantia             = json['cuantia'];
      requisitos          = json['requisitos'] ;



   }
   Ayuda.fromMap(Map snapshot,String id) :
         titulo = snapshot['titulo'] ?? '',
         descripcion = snapshot['descripcion'] ?? '',
         enlace = snapshot['enlace'] ?? '',
           image = snapshot['image'] ??" ",
          cuantia = snapshot['cuantia'],
        requisitos = snapshot['requisitos'] ;

   toJson() {
     return {
       "titulo": titulo,
       "name": descripcion,
       "enlace": enlace,
       "image": image,
       "cuantia": cuantia,
       "requisitos": requisitos
     };
   }


}
class Ayudas {

   List<Ayuda> items = new List();

   Ayudas();

   Ayudas.fromJsonList( List<dynamic> jsonList  ) {

      if ( jsonList == null ) return;

      for ( var item in jsonList  ) {
         final ayuda = new Ayuda.fromJsonMap(item);
         items.add( ayuda );
      }

   }

}
