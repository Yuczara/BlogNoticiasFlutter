import 'package:blognoticias/src/models/post.dart';
import 'package:blognoticias/src/pages/viewPost.dart';
import 'package:flutter/material.dart';
import 'add_post.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseDatabase _database = FirebaseDatabase.instance;
  String nodeName = "posts";
  List<Post> postsList = <Post>[];


  @override
  void initState() {
    _database.reference().child(nodeName).onChildAdded.listen(_childAdded);
    _database.reference().child(nodeName).onChildRemoved.listen(_childRemoves);
    _database.reference().child(nodeName).onChildChanged.listen(_childChanged);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Text("UT Noticias"),
       backgroundColor: Colors.indigo[900],
       centerTitle: true,
      ),
      body: Container(
        color: Colors.teal[200],
        child: Column(
          children: <Widget>[
            Visibility(
              visible: postsList.isEmpty,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),

            Visibility(
              visible: postsList.isNotEmpty,
              child: Flexible(
                  child: FirebaseAnimatedList(
                      query: _database.reference().child('posts'),
                      itemBuilder: (_, DataSnapshot snap, Animation<double> animation, int index){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(                            
                            child: new InkWell(
                              onTap: () {
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => PostView(postsList[index])));
                              },                
                              child: Container(
                                padding: EdgeInsets.all(14.0),
                                child: Column (
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            postsList[index].title,
                                            style: Theme.of(context).textTheme.headline5,
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            timeago.format(DateTime.fromMillisecondsSinceEpoch(postsList[index].date)),
                                            style: TextStyle(fontSize: 14.0, color: Colors.grey),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10.0,),
                                      Image.network(
                                        postsList[index].imagen,
                                        fit: BoxFit.cover
                                      ),
                                      SizedBox(height: 10.0,),
                                      Text(
                                        postsList[index].body,
                                        style: Theme.of(context).textTheme.subtitle1,
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                ),

                              ),
                            ),
                          ),
                        
                        );
                      }
                      )
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddPost()));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.indigo[900],
        tooltip: "add a post",
      ),
    );
  }

   _childAdded(Event event) {
    setState(() {
      postsList.add(Post.fromSnapshot(event.snapshot));
    });
  }

  void _childRemoves(Event event) {
    var deletedPost = postsList.singleWhere((post){
      return post.key == event.snapshot.key;
    });

    setState(() {
      postsList.removeAt(postsList.indexOf(deletedPost));
    });
  }

  void _childChanged(Event event) {
    var changedPost = postsList.singleWhere((post){
      return post.key == event.snapshot.key;
    });

    setState(() {
      postsList[postsList.indexOf(changedPost)] = Post.fromSnapshot(event.snapshot);
    });
  }
}




/*child: Card(
                            child: ListTile(
                              title: ListTile(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => PostView(postsList[index])));
                                },
                                title: Text(
                                  postsList[index].title,
                                  style: TextStyle(
                                      fontSize: 22.0, fontWeight: FontWeight.bold),
                                ),
                                trailing: Text(
                                  timeago.format(DateTime.fromMillisecondsSinceEpoch(postsList[index].date)),
                                  style: TextStyle(fontSize: 14.0, color: Colors.grey),
                                ),
                              ),
                              subtitle:Padding(
                                padding: const EdgeInsets.only(bottom: 14.0),
                                child: Text(postsList[index].body, style: TextStyle(fontSize: 18.0),),
                              ),
                              leading :SizedBox(
                                height: 100.0,
                                width: 100.0, // fixed width and height
                                child: Image.network(postsList[index].imagen,)
                              ),
                            ),
                          ),*/