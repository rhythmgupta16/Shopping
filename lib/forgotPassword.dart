import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  TextEditingController emailInputController;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  @override
  initState() {

    emailInputController = new TextEditingController();

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
              child: Form(
                key: _registerFormKey,
                child: Column(
                  children: <Widget>[
                  AppBar(             
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Text(
                      "FORGOT PASSWORD", style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    centerTitle: true,
                    leading: new IconButton(
                    icon: new Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();    
                      //Navigator.of(context).pushNamed('/login');
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
                    Container(
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
                        child: ButtonTheme(
                            minWidth: 200.0,
                            height: 50.0,
                            child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            
                            //side: BorderSide(color: Colors.red)
                            ),
                          child: Text("Proceed",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold )
                            ),
                          color: Color(0xffFBB034),
                          textColor: Colors.white,
                          
                          onPressed: () async {
                              sendPasswordResetEmail(emailInputController.text);
                              Fluttertoast.showToast(
                                  msg: "Check your email!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                        },
                        ),
                        )

                        ),

                      ],
                    ),
                  ),
                         

                ],
              ),
            )
          )
        )
      )
    );
  }

   Future<void> sendPasswordResetEmail(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
