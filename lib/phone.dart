import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shopping/googleSignIn.dart';

class PhonePage extends StatefulWidget {
  @override
  _MyAppPageState createState() => _MyAppPageState();
}

class _MyAppPageState extends State<PhonePage> {
  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FacebookLogin fbLogin = new FacebookLogin();
  bool isFacebookLoginIn = false;
  String successMessage = '';

  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context).then((value) {
        print('sign in');
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent:
              smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message}');
          });
    } catch (e) {
      handleError(e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)), //this right here
            child: Container(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'Enter SMS Code',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 85,
                        child: Column(children: [
                          TextField(
                            onChanged: (value) {
                              this.smsOTP = value;
                            },
                          ),
                          (errorMessage != ''
                              ? Text(
                                  errorMessage,
                                  style: TextStyle(color: Colors.red),
                                )
                              : Container())
                        ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: 150.0,
                        child: RaisedButton(
                          onPressed: () {
                            _auth.currentUser().then((user) {
                              if (user != null) {
                                Navigator.of(context).pop();
                                Navigator.of(context)
                                    .pushReplacementNamed('/home');
                              } else {
                                signIn();
                              }
                            });
                          },
                          child: Text(
                            "Done",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          color: const Color(0xFFFBB034),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final FirebaseUser user = await _auth.signInWithCredential(credential);
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      Firestore.instance
          .collection("users")
          .document(user.uid)
          .get()
          .then((doc) => {
                if (doc.exists)
                  {
                    //console.log("Document data:", doc.data());
                  }
                else
                  {
                    // doc.data() will be undefined in this case
                    Firestore.instance
                        .collection("users")
                        .document(user.uid)
                        .setData({
                      "uid": user.uid,
                      "fname": "Update in Edit Profile",
                      "surname": "Update in Edit Profile",
                      "email": "Update in Edit Profile",
                      "phone": "Update in Edit Profile",
                    }).then((_) {
                      print("phone database success!");
                      // return 'signInWithGoogle succeeded: $user';
                    })
                  }
              });
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      handleError(e);
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          print('sign in');
        });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Column(
              children: <Widget>[
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Text(
                    "LOGIN",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  centerTitle: true,
                  leading: new IconButton(
                    icon: new Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed('/login');
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
                ClipPath(
                  // ClipPath is used to clip the child in a custom shape
                  clipper: BottomClipper(),
                  // here is the custom clipper for bottom cut shape
                  child: Container(
                    width: MediaQuery.of(context).size.width,
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
                          child: TextField(
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone),
                                hintText: 'Enter Phone Number'),
                            onChanged: (value) {
                              this.phoneNo = value;
                            },
                          ),
                        ),
                        (errorMessage != ''
                            ? Text(
                                errorMessage,
                                style: TextStyle(color: Colors.red),
                              )
                            : Container()),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context)
                                  .pushReplacementNamed('/login');

                              //Navigator.pop(context);
                            },
                            child: RichText(
                              // RichText is used to styling a particular text span in a text by grouping them in one widget
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                text: 'Login using ',
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Email and Password',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
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
                              onTap: () {
                                verifyPhone();
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
                  clipper:
                      TopClipper(), // Custom Clipper for top clipping the social login menu box
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
                                child: Material(
                                    child: InkWell(
                                  onTap: () {
                                    facebookLogin(context).then((user) {
                                      if (user != null) {
                                        print('Logged in successfully.');
                                        Navigator.of(context).pop();
                                        Navigator.of(context)
                                            .pushReplacementNamed('/home');

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
                                ))),
                            Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Material(
                                    child: InkWell(
                                  onTap: () {
                                    signInWithGoogle().whenComplete(() {
                                      Navigator.of(context).pop();
                                      Navigator.of(context)
                                          .pushReplacementNamed('/home');
                                      //Navigator.pushNamed(context, '/home');
                                    });
                                  },
                                  child: Container(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Image.asset(
                                          'assets/gmail-icon.png',
                                          width: 80.0,
                                          height: 80.0),
                                    ),
                                  ),
                                ))),
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
                      //Navigator.of(context).pop();
                      //Navigator.of(context).pushReplacementNamed('/register');
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
        Firestore.instance
            .collection("users")
            .document(user.uid)
            .get()
            .then((doc) => {
                  if (doc.exists)
                    {
                      //console.log("Document data:", doc.data());
                    }
                  else
                    {
                      // doc.data() will be undefined in this case
                      Firestore.instance
                          .collection("users")
                          .document(user.uid)
                          .setData({
                        "uid": user.uid,
                        "fname": "Update in Edit Profile",
                        "surname": "Update in Edit Profile",
                        "email": "Update in Edit Profile",
                        "phone": "Update in Edit Profile",
                      }).then((_) {
                        print("facebook database success!");
                        // return 'signInWithGoogle succeeded: $user';
                      })
                    }
                });
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
