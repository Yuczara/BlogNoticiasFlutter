import 'package:blognoticias/src/models/post.dart';
import 'package:blognoticias/src/pages/home.dart';
import 'package:blognoticias/src/services/firestore_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditPost extends StatefulWidget {
  final Post post;

  EditPost(this.post);

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final GlobalKey<FormState> formkey = new GlobalKey();
  final picker = ImagePicker();
  String url;
  File image;


  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text("Editar Post"),
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
               TextFormField(
                  initialValue: widget.post.title,
                  decoration: InputDecoration(
                    labelText: "Titulo",
                    labelStyle: TextStyle(
                      color: Colors.teal[800],
                    ),
                   focusedBorder:OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.indigo, width: 2.0),
                    borderRadius: BorderRadius.circular(5.0),
                   ),
                   fillColor: Colors.white, filled: true,
                   ),
                   onSaved: (val) => widget.post.title = val,
                   // ignore: missing_return
                    validator: (val){
                     if(val.isEmpty ){ 
                      return "title field cant be empty";
                     }else if(val.length > 16){
                      return "title cannot have more than 16 characters ";
                     }
                    },
                    ),
                     SizedBox(height: 15.0,),
                    TextFormField(
                      initialValue: widget.post.body,
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
                      onSaved: (val) => widget.post.body = val,
                      validator: (val){
                         return val.isEmpty ? "Completa el campo": null;
                      },
                    ),
                     SizedBox(height: 15.0,),
                   Image.network(
                        widget.post.imagen,
                        fit: BoxFit.cover
                      ),
                   SizedBox(height: 15.0,),
                  RaisedButton(
                    elevation: 10.0,
                    child: Text("Guardar Post"),
                    textColor: Colors.white,
                    color: Colors.indigo[900],
                    onPressed:(){
                    uploadStatusImage();
                    insertPost();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                    },
                  ),
                ],
              )
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
      widget.post.date = DateTime.now().millisecondsSinceEpoch;
      PostService postService = PostService(widget.post.toMap());
      postService.updatePost();
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
      widget.post.imagen  = url;
      PostService postService = PostService(widget.post.toMap());
      postService.updatePost();
       // Guardar el post a firebase database: database realtime
    }
  }
}
