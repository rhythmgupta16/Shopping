import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping/googleSignIn.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.uid, FirebaseUser user}) : super(key: key); //update this to include the uid in the constructor
  final String title;
  final String uid; //include this

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FirebaseUser currentUser;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FacebookLogin fbLogin = new FacebookLogin();

  @override
  initState() {
    this.getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
  }

  void facebookLoginout() async {
    await auth.signOut();
    await fbLogin.logOut();
  print("Facebook User Sign Out");
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          FlatButton(
            child: Text("Log Out"),
            textColor: Colors.white,
            onPressed: () {
              facebookLoginout();
              signOutGoogle();
              FirebaseAuth.instance
                  .signOut()
                  .then((result) =>
                      Navigator.pushReplacementNamed(context, "/login"))
                  .catchError((err) => print(err));
                   
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue[100], Colors.blue[400]],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              // RaisedButton(
              //   onPressed: () {
              //     signOutGoogle();
              //     Navigator.pushReplacementNamed(context, "/login")
              //     .catchError((err) => print(err));
                    
              //   },
              //   color: Colors.deepPurple,
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Text(
              //       'Sign Out',
              //       style: TextStyle(fontSize: 25, color: Colors.white),
              //     ),
              //   ),
              //   elevation: 5,
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(40)),
              // )
            ],
            
             
            ),
         ),
        ),
    );
  }
}