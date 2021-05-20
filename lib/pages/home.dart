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
        primaryColor: Colors.orangeAccent,
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Row(
                children: <Widget>[
                  Text(
                    'Welcome',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: getData().asBroadcastStream(),
                      builder: (BuildContext context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (BuildContext context, int) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(snapshot.data['username'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24)),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(color: Colors.orangeAccent),
            ),
            ListTile(
              title: Text('Browse some idea!'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodData()),
                );
              },
            ),
            // ListTile(
            //   title: Text('Item 2'),
            //   onTap: () {},
            // ),
          ],
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.orangeAccent,
        ),
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
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: AssetImage('lib/assets/profile.jpg'),
                  backgroundColor: Colors.transparent,
                ),
              ],
            ),
          ),
        ],
      ),
      key: scaffoldState,

      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // WidgetBackground(),
            _buildWidgetListTodo(widthScreen, heightScreen, context),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNav(),
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
              backgroundColor: Colors.deepOrange,
              content: Text('FOOD has been added',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ));
            setState(() {});
          }
        },
        backgroundColor: Colors.orangeAccent,
      ),
      // bottomNavigationBar: CustomNavigatorHomePage(),
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
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0),
            child: Text(
              'Welcome to your \npersonal food log',
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 50),
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
                    padding: EdgeInsets.all(8.0),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot document =
                          snapshot.data.documents[index];
                      Map<String, dynamic> food = document.data;
                      String strDate = food['date'];
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
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
                            subtitle: Text(
                              food['description'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            isThreeLine: false,
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 24.0,
                                  height: 24.0,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
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
                                      backgroundColor: Colors.deepOrange,
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
                                        title: Text('Are You Sure'),
                                        content: Text(
                                            'Do you want to delete ${food['name']}?'),
                                        actions: <Widget>[
                                          RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            ),
                                            child: Text('No'),
                                            color: Colors.orangeAccent,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            ),
                                            child: Text('Delete'),
                                            color: Colors.orangeAccent,
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
