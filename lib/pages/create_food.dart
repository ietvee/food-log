import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class CreateFoodScreen extends StatefulWidget {
  final bool isEdit;
  final String documentId;
  final String name;
  final String description;
  final String date;

  CreateFoodScreen(
      {@required this.isEdit,
      this.documentId = '',
      this.name = '',
      this.description = '',
      this.date = '',
      Key key,
      this.title,
      this.uid})
      : super(key: key);
  final String title;
  final String uid;

  @override
  _CreateFoodScreenState createState() => _CreateFoodScreenState();
}

class _CreateFoodScreenState extends State<CreateFoodScreen> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final Firestore firestore = Firestore.instance;
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  final TextEditingController controllerDate = TextEditingController();

  double widthScreen;
  double heightScreen;
  DateTime date = DateTime.now();
  bool isLoading = false;

  var currentFocus;

  unfocus() {
    currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  FirebaseUser currentUser;
  @override
  void initState() {
    if (widget.isEdit) {
      date = DateFormat('dd MMMM yyyy').parse(widget.date);
      controllerName.text = widget.name;
      controllerDescription.text = widget.description;
      controllerDate.text = widget.date;
    } else {
      controllerDate.text = DateFormat('dd MMMM yyyy').format(date);
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
            child: SingleChildScrollView(
              child: Container(
                width: widthScreen,
                height: heightScreen,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildWidgetFormCreateFood(),
                    SizedBox(height: 16.0),
                    _buildWidgetFormEditFood(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetFormCreateFood() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.deepOrangeAccent,
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 20, 8, 10),
              child: Text(
                widget.isEdit ? 'Edit\nFood' : 'Add\nNew Food',
                style: Theme.of(context).textTheme.display1.merge(
                      TextStyle(color: Colors.grey[800], fontSize: 24),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetFormEditFood() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
        child: SingleChildScrollView(
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
                      child: TextField(
                        controller: controllerName,
                        decoration: InputDecoration(
                          hintText: 'food name',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontSize: 16.0),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30.0),
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
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: controllerDescription,
                        decoration: InputDecoration(
                          hintText: 'description',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontSize: 16.0),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30.0),
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
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: controllerDate,
                    decoration: InputDecoration(
                      hintText: 'Date',
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 16.0),
                    readOnly: true,
                    onTap: () async {
                      DateTime today = DateTime.now();
                      DateTime datePicker = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: today,
                        lastDate: DateTime(2022),
                      );
                      if (datePicker != null) {
                        date = datePicker;
                        controllerDate.text =
                            DateFormat('dd MMMM yyyy').format(date);
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: RaisedButton(
                  color: Colors.deepOrangeAccent,
                  child: Text(
                    widget.isEdit ? 'UPDATE' : 'CREATE',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  onPressed: () async {
                    String name = controllerName.text;
                    String description = controllerDescription.text;
                    String date = controllerDate.text;
                    if (name.isEmpty) {
                      _showSnackBarMessage('Name is required');
                      return;
                    } else if (description.isEmpty) {
                      _showSnackBarMessage('Description is required');
                      return;
                    }
                    setState(() => isLoading = true);
                    if (widget.isEdit) {
                      DocumentReference documentFood = firestore.document(
                          'users/${currentUser.uid}/foods/${widget.documentId}');
                      firestore.runTransaction((transaction) async {
                        DocumentSnapshot food =
                            await transaction.get(documentFood);
                        if (food.exists) {
                          await transaction.update(
                            documentFood,
                            <String, dynamic>{
                              'name': name,
                              'description': description,
                              'date': date,
                            },
                          );
                          Navigator.pop(context, true);
                        }
                      });
                    } else {
                      CollectionReference foods = firestore
                          .collection("users")
                          .document(currentUser.uid)
                          .collection("foods");
                      DocumentReference result =
                          await foods.add(<String, dynamic>{
                        'name': name,
                        'description': description,
                        'date': date,
                      });
                      if (result.documentID != null) {
                        Navigator.pop(context, true);
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildWidgetBtnCreateFood() {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
  //     child: RaisedButton(
  //       color: Colors.deepOrangeAccent,
  //       child: Text(
  //         widget.isEdit ? 'UPDATE' : 'CREATE',
  //         style: TextStyle(
  //           fontSize: 16.0,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       textColor: Colors.white,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10.0),
  //       ),
  //       onPressed: () async {
  //         String name = controllerName.text;
  //         String description = controllerDescription.text;
  //         String date = controllerDate.text;
  //         if (name.isEmpty) {
  //           _showSnackBarMessage('Name is required');
  //           return;
  //         } else if (description.isEmpty) {
  //           _showSnackBarMessage('Description is required');
  //           return;
  //         }
  //         setState(() => isLoading = true);
  //         if (widget.isEdit) {
  //           DocumentReference documentFood = firestore.document(
  //               'users/${currentUser.uid}/foods/${widget.documentId}');
  //           firestore.runTransaction((transaction) async {
  //             DocumentSnapshot food = await transaction.get(documentFood);
  //             if (food.exists) {
  //               await transaction.update(
  //                 documentFood,
  //                 <String, dynamic>{
  //                   'name': name,
  //                   'description': description,
  //                   'date': date,
  //                 },
  //               );
  //               Navigator.pop(context, true);
  //             }
  //           });
  //         } else {
  //           CollectionReference foods = firestore
  //               .collection("users")
  //               .document(currentUser.uid)
  //               .collection("foods");
  //           DocumentReference result = await foods.add(<String, dynamic>{
  //             'name': name,
  //             'description': description,
  //             'date': date,
  //           });
  //           if (result.documentID != null) {
  //             Navigator.pop(context, true);
  //           }
  //         }
  //       },
  //     ),
  //   );
  // }

  void _showSnackBarMessage(String message) {
    scaffoldState.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.deepOrangeAccent,
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
