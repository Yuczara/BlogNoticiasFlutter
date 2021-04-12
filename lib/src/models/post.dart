import 'package:firebase_database/firebase_database.dart';
class Post{

  static const KEY = "key";
  static const DATE = "date";
  static const TITLE = "title";
  static const BODY = "body";
  static const IMAGEN = "imagen";

   int date;
   String key;
   String title;
   String body;
   String imagen;

  Post(this.date, this.title, this.body, this.imagen);

//  String get key  => _key;
//  String get date  => _date;
//  String get title  => _title;
//  String get body  => _body;
// String get url  => url;


  Post.fromSnapshot(DataSnapshot snap):
        this.key = snap.key,
        this.body = snap.value[BODY],
        this.date = snap.value[DATE],
        this.title = snap.value[TITLE],
        this.imagen = snap.value[IMAGEN];
        

  Map toMap(){
    return {IMAGEN: imagen ,BODY: body, TITLE: title, DATE: date, KEY: key};
  }
}