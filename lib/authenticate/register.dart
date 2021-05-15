import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/pages/home.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  TextEditingController usernameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;

  @override
  initState() {
    firstNameInputController = new TextEditingController();
    lastNameInputController = new TextEditingController();
    usernameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Invalid email format';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.orangeAccent),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                Text('Register an account',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 32,
                      color: Colors.black54,
                    )),
                SizedBox(height: 60),
                Form(
                  key: _registerFormKey,
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
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'first name',
                                  border: InputBorder.none,
                                ),
                                controller: firstNameInputController,
                                validator: (value) {
                                  if (value.length < 3) {
                                    return "Please enter a valid first name.";
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
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
                              child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'last name',
                                    border: InputBorder.none,
                                  ),
                                  controller: lastNameInputController,
                                  validator: (value) {
                                    if (value.length < 3) {
                                      return "Please enter a valid last name.";
                                    }
                                  }),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
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
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'username',
                                  border: InputBorder.none,
                                ),
                                controller: usernameInputController,
                                // validator: (value) {
                                //   if (value.length < 3) {
                                //     return "Please enter a valid last name.";
                                //   }
                                // }
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
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
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'email',
                                  border: InputBorder.none,
                                ),
                                controller: emailInputController,
                                keyboardType: TextInputType.emailAddress,
                                validator: emailValidator,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
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
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'password',
                                  border: InputBorder.none,
                                ),
                                controller: pwdInputController,
                                obscureText: true,
                                validator: pwdValidator,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
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
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'confirm password',
                                  border: InputBorder.none,
                                ),
                                controller: confirmPwdInputController,
                                obscureText: true,
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
                            'Create',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child:
                                Icon(Icons.arrow_forward, color: Colors.white),
                            color: Colors.orangeAccent,
                            textColor: Colors.white,
                            onPressed: () {
                              if (_registerFormKey.currentState.validate()) {
                                if (pwdInputController.text ==
                                    confirmPwdInputController.text) {
                                  FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                          email: emailInputController.text,
                                          password: pwdInputController.text)
                                      .then((currentUser) => Firestore.instance
                                          .collection("users")
                                          .document(currentUser.uid)
                                          .setData({
                                            "uid": currentUser.uid,
                                            "fname":
                                                firstNameInputController.text,
                                            "surname":
                                                lastNameInputController.text,
                                            "username":
                                                usernameInputController.text,
                                            "email": emailInputController.text,
                                          })
                                          .then((result) => {
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HomeScreen(
                                                              uid: currentUser
                                                                  .uid,
                                                            )),
                                                    (_) => false),
                                                firstNameInputController
                                                    .clear(),
                                                lastNameInputController.clear(),
                                                emailInputController.clear(),
                                                pwdInputController.clear(),
                                                confirmPwdInputController
                                                    .clear()
                                              })
                                          .catchError((err) => print(err)))
                                      .catchError((err) => print(err));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Error"),
                                          content: Text(
                                              "The passwords do not match"),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text("Close"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        );
                                      });
                                }
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Already have an account?"),
                          SizedBox(width: 10),
                          GestureDetector(
                              child: Text("Login here!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.indigoAccent[400])),
                              onTap: () {
                                Navigator.pop(context);
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
