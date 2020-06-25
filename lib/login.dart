import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping/home.dart';
import 'package:shopping/googleSignIn.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';


class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FacebookLogin fbLogin = new FacebookLogin();
  bool isFacebookLoginIn = false;
  String errorMessage = '';
  String successMessage = '';

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
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
     
    return WillPopScope(
    onWillPop: _onBackPressed,
    child: new Scaffold(        
        body: Container(
            //padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xffFBB034), Color(0xffF8B313)],
                ),
              ),
              child: Form(
              key: _loginFormKey,
              child: Column(
                children: <Widget>[
                 AppBar(             
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Text(
                    "LOGIN", style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  centerTitle: true,
                  leading: new IconButton(
                    icon: new Icon(Icons.arrow_back),
                    onPressed: () {
                      _onBackPressed();
                      },
                    ),
                  // Actions are identified as buttons which are added at the right of App Bar
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/logo.png'),
                      )
                    ],
                  ),
                  ClipPath( // ClipPath is used to clip the child in a custom shape
                    clipper: BottomClipper(),
                    // here is the custom clipper for bottom cut shape
                    child: Container(
                      width: MediaQuery
                        .of(context)
                        .size
                        .width,
                      padding: EdgeInsets.only(top: 40, bottom: 30),
                      margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(1, 2),
                              spreadRadius: 1.0,
                              blurRadius: 5.0)
                            ],
                        borderRadius: BorderRadius.circular(20),
                      ),

                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            labelText: 'Email'
                          ),
                          controller: emailInputController,
                          keyboardType: TextInputType.emailAddress,
                          validator: emailValidator,
                          ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              labelText: 'Password',
                              suffixIcon: Icon(Icons.remove_red_eye),
                            ),
                            controller: pwdInputController,
                            obscureText: true,
                            validator: pwdValidator,
                            ),
                        ),
                        Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 18.0),
                          child: InkWell( // InkWell widget makes the widget clickable and provide call back for touch events
                            onTap: () {
                              print("Forget Password tap");
                            },
                            child: Text(
                              'Forget Password?',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: Color(0xffFBB034),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: InkWell(
                          onTap: () {
                            
                            Navigator.pushNamed(context, '/phone');
                          },
                          child: RichText( // RichText is used to styling a particular text span in a text by grouping them in one widget
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,),
                              text: 'Login using ',
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Mobile Number and OTP',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          InkWell(
                            onTap: (){
                            if (_loginFormKey.currentState.validate()) {
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
                                            builder: (context) => HomePage(
                                                  title: "Home",
                                                  uid: currentUser.uid,
                                                ))))
                              .catchError((err) => print(err)))
                              .catchError((err) => print(err));
                            }
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 20, top: 10),
                              decoration: BoxDecoration(
                                  color: Color(0xffFBB034),
                                  borderRadius: BorderRadius.circular(30)),
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                Icons.navigate_next,
                                size: 40,
                                color: Colors.white,
                              ),
                              ),
                              ),
                              ],
                            )
                          ],
                        ),
                      ),
                      ),

                 ClipPath(
                    clipper: TopClipper(), // Custom Clipper for top clipping the social login menu box
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(top: 50, bottom: 50),
                      margin: EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              offset: Offset(1, 2),
                              spreadRadius: 1.0,
                              blurRadius: 5.0),
                        ],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Or",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xff898989),
                            ),
                         ),
                          Text(
                            "Login with Social Media",
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xff898989),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: 
                                Material(
                                  child: InkWell(
                                  onTap: () {
                                     facebookLogin(context).then((user) {
                                      if (user != null) {
                                        print('Logged in successfully.');
                                        Navigator.pushNamed(context, '/home');
                                        isFacebookLoginIn = true;
                                      } else {
                                        print('Error while Login.');
                                      }
                                    });
                                  },
                                  child: Container(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Image.asset('assets/fb-icon.png',
                                        width: 80.0, height: 80.0),
                                        ),
                                        ),
                                  )
                                )
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: 
                                Material(
                                  child: InkWell(
                                  onTap: () {
                                    signInWithGoogle().whenComplete(() {
                                    Navigator.pushNamed(context, '/home');
                                    });
                                  },
                                  child: Container(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Image.asset('assets/gmail-icon.png',
                                        width: 80.0, height: 80.0),
                                        ),
                                        ),
                                  )
                                )
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                   Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/register");
                      },
                    child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Click here to signup",
                              style:
                            TextStyle(decoration: TextDecoration.underline),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
        ),
      ),
    ),
  ),
  );
}
    
                  


Future<FirebaseUser> facebookLogin(BuildContext context) async {
    FirebaseUser currentUser;
    //fbLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    // if you remove above comment then facebook login will take username and pasword for login in Webview
    try {
      final FacebookLoginResult facebookLoginResult =
          await fbLogin.logInWithReadPermissions(['email', 'public_profile']);
      if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
        FacebookAccessToken facebookAccessToken =
            facebookLoginResult.accessToken;
        final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: facebookAccessToken.token);
        final FirebaseUser user = await auth.signInWithCredential(credential);
        assert(user.email != null);
        assert(user.displayName != null);
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);
        currentUser = await auth.currentUser();
        assert(user.uid == currentUser.uid);
        Firestore.instance.collection("users").document(user.uid)
          .get()
          .then((doc) => {
            if (doc.exists) {
              //console.log("Document data:", doc.data());
            } else {
              // doc.data() will be undefined in this case
              Firestore.instance.collection("users").document(user.uid).setData({
                        "uid": user.uid,
                        "fname": "Update in Edit Profile",
                        "surname": "Update in Edit Profile",
                        "email":"Update in Edit Profile",
                      }).then((_){
                          print("facebook database success!");
                          // return 'signInWithGoogle succeeded: $user';
                          })
              
          }}
          );
        return currentUser;
      }
    } catch (e) {
      print(e);
    }
    return currentUser;
  }

  Future<bool> facebookLoginout() async {
    await auth.signOut();
    await fbLogin.logOut();
    return true;
  }

  Future<bool> _onBackPressed() {
   
  return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(25.0)), //this right here
            child: Container(
              height: 220,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child:
                        TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Are you sure you want to exit?'),
                      ),
                    ),
                    Row(
                    children: <Widget>[
                      Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: 
                    SizedBox(
                      width: 100.0,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: const Color(0xFFFBB034),
                      ),
                    ),
                      ),
                      Padding(
                      padding: const EdgeInsets.all(10.0),
                      child:
                    SizedBox(
                      width: 100.0,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          "Yes",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: const Color(0xFFFBB034),
                      ),
                    ),
                      ),
                    ]
                      
                    ),
                    

                  ],
                ),
              ),
            ),
          );
        })??
      false;
}




  
}

// Custom Clipper Class
class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // Add Path lines to form slight cut
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height - 50);
    return path;
  }

  // we don't need to render it again and again as UI renders
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(size.width, 50);
    path.lineTo(size.width, size.height + 10);
    path.lineTo(0, size.height + 10);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}