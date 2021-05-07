import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  Profile({Key key, this.title, this.uid}) : super(key: key);
  final String title;
  final String uid;
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Firestore firestore = Firestore.instance;
  FirebaseUser currentUser;

  @override
  initState() {
    this.getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  Future<DocumentSnapshot> getDocument() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    return await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.orangeAccent,
          ),
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                child: FutureBuilder(
                  future: getDocument(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Text(
                          snapshot.data["fname"].toString().toUpperCase());
                    } else if (snapshot.connectionState ==
                        ConnectionState.none) {
                      return Text("No data");
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
              Container(
                child: FutureBuilder(
                  future: getDocument(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Text(
                          snapshot.data["surname"].toString().toUpperCase());
                    } else if (snapshot.connectionState ==
                        ConnectionState.none) {
                      return Text("No data");
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
              Text(
                'See you again soon !',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.orangeAccent,
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
        ));
  }
}
