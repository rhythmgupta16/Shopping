import 'package:flutter/material.dart';
import 'register.dart';
import 'splash.dart';
import 'login.dart';
import 'home.dart';
import 'phone.dart';
import 'editProfile.dart';
import 'forgotPassword.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: SplashPage(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => HomePage(title: 'Home'),
          '/login': (BuildContext context) => LoginPage(),
          '/register': (BuildContext context) => RegisterPage(),
          '/phone' : (BuildContext context) => PhonePage(),
          '/editProfile' : (BuildContext context) => EditProfilePage(),
          '/forgotPassword' : (BuildContext context) => ForgotPasswordPage(),
        });
  }
}