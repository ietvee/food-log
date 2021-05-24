import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app/pages/editProfile.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.red[400]),
      home: Profile(),
    );
  }
}

class Profile extends StatefulWidget {
  Profile({Key key, this.title, this.uid}) : super(key: key);
  final String title;
  final String uid;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final Firestore firestore = Firestore.instance;
  FirebaseUser currentUser;

  // final Stream<QuerySnapshot> _getDocument = (() {
  //   Future<void>.delayed(const Duration(seconds: 1));

  //   Future<void>.delayed(const Duration(seconds: 1));
  // })();

  @override
  initState() {
    this.getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  // Future<DocumentSnapshot> getDocument() async {
  //   var firebaseUser = await FirebaseAuth.instance.currentUser();
  //   return await Firestore.instance
  //       .collection("users")
  //       .document(firebaseUser.uid)
  //       .get();
  // }

  Stream<DocumentSnapshot> getData() async* {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    yield* Firestore.instance
        .collection('users')
        .document(user.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double widthScreen = mediaQueryData.size.width;
    double heightScreen = mediaQueryData.size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: IconThemeData(
          color: Colors.red[400],
        ),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      key: scaffoldState,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            _buildWidgetListTodo(widthScreen, heightScreen, context),
          ],
        ),
      ),
    );
  }

  Container _buildWidgetListTodo(
      double widthScreen, double heightScreen, BuildContext context) {
    return Container(
      width: widthScreen,
      height: heightScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // FutureBuilder(
          //   future: getDocument(),
          //   builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       return Text(snapshot.data["fname"].toString().toUpperCase(),
          //           style:
          //               TextStyle(fontWeight: FontWeight.bold, fontSize: 38));
          //     } else if (snapshot.connectionState == ConnectionState.none) {
          //       return Text("No data");
          //     }
          //     return CircularProgressIndicator();
          //   },
          // ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 30, 20, 30),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 60.0,
                  backgroundImage: AssetImage('lib/assets/avatar.png'),
                  backgroundColor: Colors.transparent,
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream: getData(),
            builder: (BuildContext context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (BuildContext context, int) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(50, 0, 20, 80),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(snapshot.data['username'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 38)),
                        IconButton(
                          icon: const Icon(Icons.mode_edit),
                          onPressed: () {
                            setState(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return EditProfile(
                                    isEdit: true,
                                    // documentId: document.documentID,
                                    username: snapshot.data['username'],
                                  );
                                }),
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
              // return ListView.builder(
              //     padding: EdgeInsets.all(8.0),
              //     itemCount: snapshot.data.documents.length,
              //     itemBuilder: (BuildContext context, int index) {
              //       DocumentSnapshot document =
              //           snapshot.data.documents[index];
              //       Map<String, dynamic> food = document.data;
              //       return ListTile(
              //         title: IconButton(
              //           icon: const Icon(Icons.mode_edit),
              //           onPressed: () {
              //             setState(() {
              //               Navigator.push(
              //                 context,
              //                 MaterialPageRoute(builder: (context) {
              //                   return EditProfile(
              //                     isEdit: true,
              //                     documentId: document.documentID,
              //                     fname: food['fname'],
              //                   );
              //                 }),
              //               );
              //             });
              //           },
              //         ),
              //         trailing: Text(snapshot.data["fname"]),
              //       );
              //     });
            },
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(50, 10, 50, 60),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.red[400],
                  onPressed: () {
                    FirebaseAuth.instance
                        .signOut()
                        .then((result) =>
                            Navigator.pushReplacementNamed(context, "/login"))
                        .catchError((err) => print(err));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
