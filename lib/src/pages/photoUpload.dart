/*import 'package:blognoticias/src/pages/home_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class PhotoUpload extends StatefulWidget {
  @override
  _PhotoUploadState createState() => _PhotoUploadState();
}

class _PhotoUploadState extends State<PhotoUpload> {
  File image;
  final picker = ImagePicker();

  final formKey = GlobalKey<FormState>();
  String _myValue;
  String url;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("UploadImage"),
      centerTitle: true,
      ),
      body: Center(
        child: image == null
        ? Text("selecciona una imagen")
        : enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: "Add image",
        child: Icon(Icons.add_a_photo),
        ),
    );
  }
  
  Future getImage() async {
    var tempImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (tempImage != null) {
        image = File(tempImage.path);
      } else {
        print('No image selected.');
      }
    });
  }


  Widget enableUpload(){
    return SingleChildScrollView(
      child: Container(
        child:Padding(
          padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Image.file(
            image, 
            height: 300.0, 
            width:  600.0,
            ),
          SizedBox(
            height: 15.0,
          ),
          TextFormField(
            decoration: InputDecoration(labelText:"Descripcion"),
            validator: (value) {
              return value.isEmpty ? "Description is required": null;
            },
            onSaved: (value){
              return _myValue = value;
            },
          ),
          SizedBox(height: 15.0,
          ),
          RaisedButton(
            elevation: 10.0,
            child: Text("Add aNew post"),
            textColor: Colors.white,
            color: Colors.indigo[900],
            onPressed: uploadStatusImage,
          )
          ],
        ),
      ),
     ),
    ),
    );
  }

  void uploadStatusImage() async {
    if(validateAndSave()){
      ///subir la imagen a firebase storage
      final StorageReference postImageRef = 
      FirebaseStorage.instance.ref().child("Post Images");
      var timeKey = DateTime.now();
      final StorageUploadTask uploadTask = 
      postImageRef.child(timeKey.toString()+".jpg").putFile(image);
      var imageUrl = await(await uploadTask.onComplete).ref.getDownloadURL();
      url = imageUrl.toString();
      print("Image url: "+ url );
      
       // Guardar el post a firebase database: database realtime
      saveToDatabase(url);
      
      // Regresar a Home
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomePage();
    }));
    }
  }
 
  void saveToDatabase(String url){
    //guardar post(imagen, decripcion, date , time)
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat('MMM s ,yyyy');
    var formatTime = DateFormat('EEEE, hh:mm aaa');
   
    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data ={
      "image" :url,
      "desciption" : _myValue,
      "date" : date,
      "time" : time
    };
    ref.child("Posts").push().set(data);
    
  }

  bool validateAndSave(){
    final form= formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    } else {
      return false;
    }
  }
}*/
/*: if
          request.time < timestamp.date(2021, 4, 30) */