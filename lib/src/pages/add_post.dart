import 'package:blognoticias/src/models/post.dart';
import 'package:blognoticias/src/services/firestore_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final GlobalKey<FormState> formkey = new GlobalKey();
  Post post = Post(0, " ", " "," ");
  File image;
  final picker = ImagePicker();
  String url;
  //final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nuevo Post"),
        backgroundColor: Colors.indigo[900],
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
      child: Container(
        child:Padding(
          padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formkey,
        child: Column(
          children: <Widget>[
            Container(
              child: image == null
             ? Text("selecciona una imagen")
             :  Image.file(
                  image, 
                  height: 300.0, 
                  width:  600.0,
                  ),
            ),            
          SizedBox(
            height: 15.0,
          ),
          TextFormField(
             decoration: InputDecoration(
               labelText: "Titulo",
               labelStyle: TextStyle(
                 color: Colors.teal[800],
                 fontSize: 20.0
               ),
               focusedBorder:OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.indigo, width: 2.0),
                borderRadius: BorderRadius.circular(5.0),
               ),
               fillColor: Colors.white, filled: true,
             ),
                onSaved: (val) => post.title = val,
              validator: (val) {
                return val.isEmpty ? "Completa el campo": null;
              },
          ),
          SizedBox(height: 15.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Contenido",
              labelStyle: TextStyle(
                color: Colors.teal[800],
              ),
              focusedBorder:OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.indigo, width: 2.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              fillColor: Colors.white, filled: true,
            ),
            onSaved: (val) => post.body = val,
            validator: (val){
             return val.isEmpty ? "Completa el campo": null;
            },
          ),
           SizedBox(height: 15.0,
          ),
          RaisedButton(
            elevation: 10.0,
            child: Text("Guardar Post"),
            textColor: Colors.white,
            color: Colors.indigo[900],
            onPressed:(){
             uploadStatusImage();
             insertPost();
             Navigator.pop(context);
            },
          )
          ],
        ),
      ),
     ),
    ),
    ),
    floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: "Add image",
        child: Icon(Icons.add_a_photo),
        backgroundColor: Colors.indigo[900],
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

  void insertPost() {
    final FormState form = formkey.currentState;
    if(form.validate()){
      form.save();
      form.reset();
      post.date = DateTime.now().millisecondsSinceEpoch;
     // PostService postService = PostService(post.toMap());
     // postService.addPost();
    }
  }

 bool validateAndSave(){
    final FormState form = formkey.currentState;
    if(form.validate()){
      return true;
    } else {
      return false;
    }
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
      print("IMAGE URL: "+ url );
      post.imagen = url;
      PostService postService = PostService(post.toMap());
      postService.addPost();
       // Guardar el post a firebase database: database realtime
    }
  }
}

