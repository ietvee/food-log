import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfile extends StatefulWidget {
  final bool isEdit;
  final String documentId;
  final String username;

  EditProfile(
      {@required this.isEdit,
      this.documentId = '',
      this.username = '',
      Key key,
      this.title,
      this.uid})
      : super(key: key);
  final String title;
  final String uid;

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final Firestore firestore = Firestore.instance;
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  final TextEditingController controllerDate = TextEditingController();

  double widthScreen;
  double heightScreen;
  DateTime date = DateTime.now();
  bool isLoading = false;

  FirebaseUser currentUser;
  @override
  void initState() {
    if (widget.isEdit) {
      controllerName.text = widget.username;
    }
    this.getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    widthScreen = mediaQueryData.size.width;
    heightScreen = mediaQueryData.size.height;

    return Scaffold(
      key: scaffoldState,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Container(
              width: widthScreen,
              height: heightScreen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 16.0),
                  _buildWidgetFormEditProfile(),
                  isLoading
                      ? Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.orangeAccent),
                            ),
                          ),
                        )
                      : _buildWidgetBtnUpdateProfile(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetFormEditProfile() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(196, 135, 198, .3),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    )
                  ]),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: controllerName,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 16.0),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetBtnUpdateProfile() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 250),
      child: RaisedButton(
        color: Colors.orangeAccent,
        child: Text(
          'UPDATE',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        onPressed: () async {
          String name = controllerName.text;

          if (name.isEmpty) {
            _showSnackBarMessage('Cannot be left empty');
            return;
          }
          setState(() => isLoading = true);
          if (widget.isEdit) {
            DocumentReference documentFood =
                firestore.document('users/${currentUser.uid}');
            firestore.runTransaction((transaction) async {
              DocumentSnapshot food = await transaction.get(documentFood);
              if (food.exists) {
                await transaction.update(
                  documentFood,
                  <String, dynamic>{
                    'username': name,
                  },
                );
                Navigator.pop(context, true);
              }
            });
          }
        },
      ),
    );
  }

  void _showSnackBarMessage(String message) {
    scaffoldState.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.deepOrange,
      content: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(message,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ),
      ),
    ));
  }
}
