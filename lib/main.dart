import 'package:flutter/material.dart';
import 'package:food_app/authenticate/login.dart';
import 'package:food_app/authenticate/register.dart';
import 'package:food_app/pages/home.dart';
import 'package:food_app/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.indigoAccent[400],
          fontFamily: 'Roboto',
        ),
        home: SplashScreen(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => HomeScreen(),
          '/login': (BuildContext context) => LoginPage(),
          '/register': (BuildContext context) => RegisterPage(),
        });
  }
}
