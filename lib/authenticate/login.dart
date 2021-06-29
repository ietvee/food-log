import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/pages/home.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;

  @override
  void initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();

    FirebaseAuth.instance.currentUser().then((currentUser) {
      if (currentUser != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(uid: currentUser.uid)),
            (Route<dynamic> route) => true);
      }
    });
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter an email';
    } else if (!regex.hasMatch(value)) {
      return "Invalid email";
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter a password';
    } else if (value.length < 8) {
      return 'Incorrect password \nThe password you entered is incorrect. Please try again';
    } else {
      return null;
    }
  }

  bool _obscureText = true;

  String _password;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
            padding: const EdgeInsets.fromLTRB(20, 160, 20, 0),
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Food Log',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 48,
                      color: Colors.black54,
                      letterSpacing: 2,
                    )),
                Text('Welcome back!',
                    style: TextStyle(
                      fontSize: 18,
                    )),
                SizedBox(height: 60),
                Form(
                  key: _loginFormKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
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
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "email",
                                ),
                                controller: emailInputController,
                                keyboardType: TextInputType.emailAddress,
                                validator: emailValidator,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
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
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "password",
                                  suffixIcon: IconButton(
                                      onPressed: _toggle,
                                      icon: _obscureText
                                          ? Icon(
                                              Icons.visibility_off,
                                              color: Colors.deepOrangeAccent,
                                            )
                                          : Icon(Icons.visibility,
                                              color: Colors.deepOrangeAccent)),
                                ),
                                onSaved: (val) => _password = val,
                                controller: pwdInputController,
                                obscureText: _obscureText,
                                validator: pwdValidator,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child:
                                Icon(Icons.arrow_forward, color: Colors.white),
                            color: Colors.deepOrangeAccent,
                            textColor: Colors.white,
                            onPressed: () {
                              if (_loginFormKey.currentState.validate()) {
                                if (pwdInputController.text ==
                                    pwdInputController.text) {
                                  FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: emailInputController.text,
                                          password: pwdInputController.text)
                                      .then((currentUser) => Firestore.instance
                                          .collection("users")
                                          .document(currentUser.uid)
                                          .get()
                                          .then((DocumentSnapshot result) =>
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomeScreen(
                                                            uid:
                                                                currentUser.uid,
                                                          ))))
                                          // Navigator.pushNamed(
                                          //     context, "/home"))
                                          .catchError((err) => print(err)))
                                      .catchError((err) => showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(err.toString()),
                                              content: Text(""),
                                              actions: <Widget>[
                                                RaisedButton(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Text('Close',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                  color:
                                                      Colors.deepOrangeAccent,
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          }));
                                }
                                // } else {
                                //   showDialog(
                                //       context: context,
                                //       builder: (BuildContext context) {
                                //         return AlertDialog(
                                //           title: Text("Error"),
                                //           content: Text(
                                //               "The passwords do not match"),
                                //           actions: <Widget>[
                                //             FlatButton(
                                //               child: Text("Close"),
                                //               onPressed: () {
                                //                 Navigator.of(context).pop();
                                //               },
                                //             )
                                //           ],
                                //         );
                                //       });
                                // }
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Dont have an account?",
                              style: TextStyle(
                                fontSize: 16,
                              )),
                          SizedBox(width: 10),
                          GestureDetector(
                              child: Text("Register here!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.indigoAccent[400])),
                              onTap: () {
                                Navigator.pushNamed(context, "/register");
                              })
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ))));
  }
}
