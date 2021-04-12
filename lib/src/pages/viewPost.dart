import 'package:blognoticias/src/models/post.dart';
import 'package:blognoticias/src/pages/edit_post.dart';
import 'package:blognoticias/src/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostView extends StatefulWidget {
  final Post post;

  PostView(this.post);

  @override
  _PostViewState createState() => _PostViewState();
}


class _PostViewState extends State<PostView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.title),        
       backgroundColor: Colors.indigo[900],
      ),
      body: Column(
          children: <Widget>[
            Container(
              color: Colors.teal,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        timeago.format(DateTime.fromMillisecondsSinceEpoch(widget.post.date)),
                        style: TextStyle(fontSize: 14.0, color: Colors.grey[200]),
                      ),
                    ),),
                  IconButton(icon: Icon(Icons.delete),
                  color: Colors.indigo[900],
                  onPressed: (){
                    PostService postService = PostService(widget.post.toMap());
                    postService.deletePost();
                    Navigator.pop(context);

                  },),
                  IconButton(icon: Icon(Icons.edit),
                  color: Colors.indigo[900],
                    onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EditPost(widget.post)));
                    },),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color:Colors.white,
                child: Text(
                  widget.post.body,
                  style: TextStyle(fontSize: 15.0,),
                  ),
              ),
            ),
            Image.network(
               widget.post.imagen,
               //fit: BoxFit.cover
               height: 400.0,
            ),
          ],
        ),
      );
  }
}
