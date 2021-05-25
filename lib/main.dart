import 'package:flutter/material.dart';
import 'package:food_app/authenticate/login.dart';
import 'package:food_app/authenticate/register.dart';
import 'package:food_app/pages/home.dart';
import 'package:food_app/splash.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: (context, widget) => ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(context, widget),
            maxWidth: 1200,
            minWidth: 480,
            defaultScale: true,
            // responsive
            breakpoints: [
              ResponsiveBreakpoint.resize(480, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: TABLET),
              ResponsiveBreakpoint.resize(1000, name: DESKTOP),
            ],
            background: Container(color: Color(0xFFF5F5F5))),
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.indigoAccent[400],
          fontFamily: 'Prompt',
        ),
        home: SplashScreen(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => HomeScreen(),
          '/login': (BuildContext context) => LoginPage(),
          '/register': (BuildContext context) => RegisterPage(),
        });
  }
}
