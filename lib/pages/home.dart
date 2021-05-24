import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app/pages/create_food.dart';
import 'package:food_app/pages/browseFood.dart';
import 'package:food_app/pages/profile.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red[400],
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title, this.uid}) : super(key: key);
  final String title;
  final String uid;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
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
        iconTheme: IconThemeData(color: Colors.red[400]),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    backgroundImage: AssetImage('lib/assets/avatar.png'),
                    backgroundColor: Colors.transparent,
                  ),
                ],
              ),
            ),
          ),
        ],
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
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          bool result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateFoodScreen(isEdit: false)));
          if (result != null && result) {
            scaffoldState.currentState.showSnackBar(SnackBar(
              backgroundColor: Colors.red[400],
              content: Text('FOOD has been added',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ));
            setState(() {});
          }
        },
        backgroundColor: Colors.red[400],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Container _buildWidgetListTodo(
      double widthScreen, double heightScreen, BuildContext context) {
    return Container(
      width: widthScreen,
      height: heightScreen,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Hello',
                          style: TextStyle(fontSize: 24),
                        ),
                        SizedBox(width: 8),
                        StreamBuilder(
                          stream: getData().asBroadcastStream(),
                          builder: (BuildContext context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return Text(snapshot.data['username'],
                                style: TextStyle(fontSize: 24));
                          },
                        ),
                        Text(
                          ',',
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Browse Food',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.red[400],
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FoodData()),
                        );
                      },
                    ),
                  ],
                ),
                Text('It\s time to share your food journey! ')
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('users')
                    .document(widget.uid)
                    .collection('foods')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    // padding: EdgeInsets.all(8.0),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot document =
                          snapshot.data.documents[index];
                      Map<String, dynamic> food = document.data;
                      String strDate = food['date'];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          // height: 200,
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
                          child: ListTile(
                            title: Text(food['name']),
                            subtitle: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Text(
                                      food['description'],
                                      maxLines: 100,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 24.0,
                                      height: 24.0,
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${int.parse(strDate.split(' ')[0])}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      strDate.split(' ')[1],
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.0),
                              ],
                            ),
                            isThreeLine: true,
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 24.0,
                                  height: 24.0,
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${int.parse(strDate.split(' ')[0])}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  strDate.split(' ')[1],
                                  style: TextStyle(fontSize: 12.0),
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton(
                              itemBuilder: (BuildContext context) {
                                return List<PopupMenuEntry<String>>()
                                  ..add(PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Text('Edit'),
                                  ))
                                  ..add(PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ));
                              },
                              onSelected: (String value) async {
                                if (value == 'edit') {
                                  bool result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return CreateFoodScreen(
                                        isEdit: true,
                                        documentId: document.documentID,
                                        name: food['name'],
                                        description: food['description'],
                                        date: food['date'],
                                      );
                                    }),
                                  );
                                  if (result != null && result) {
                                    scaffoldState.currentState
                                        .showSnackBar(SnackBar(
                                      backgroundColor: Colors.red[400],
                                      content: Text('FOOD has been updated',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                    ));
                                    setState(() {});
                                  }
                                } else if (value == 'delete') {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Are You Sure?'),
                                        content: Text(
                                            'Do you want to delete ${food['name']}?'),
                                        actions: <Widget>[
                                          RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text('No'),
                                            color: Colors.red[400],
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text('Delete'),
                                            color: Colors.red[400],
                                            onPressed: () {
                                              document.reference.delete();
                                              Navigator.pop(context);
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Icon(Icons.more_vert),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
