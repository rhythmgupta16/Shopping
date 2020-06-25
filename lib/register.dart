import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping/home.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;

  @override
  initState() {
    firstNameInputController = new TextEditingController();
    lastNameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
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
                      "REGISTER", style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    centerTitle: true,
                    //leading: Icon(Icons.arrow_back),
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
                            labelText: 'First Name'
                          ),
                          controller: firstNameInputController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.length < 3) {
                              return "Please enter a valid first name.";
                            }
                          },
                          ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            labelText: 'Last Name'
                          ),
                          controller: lastNameInputController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.length < 3) {
                              return "Please enter a valid last name.";
                            }
                          },
                          ),
                      ),
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
                        Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              labelText: 'Confirm Password',
                              suffixIcon: Icon(Icons.remove_red_eye),
                            ),
                            controller: confirmPwdInputController,
                            obscureText: true,
                            validator: pwdValidator,
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
                          
                          onPressed: () {
                            if (_registerFormKey.currentState.validate()) {
                              if (pwdInputController.text ==
                                  confirmPwdInputController.text) {
                                FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: emailInputController.text,
                                        password: pwdInputController.text)
                                    .then((currentUser) => Firestore.instance
                                        .collection("users")
                                        .document(currentUser.uid)
                                        .setData({
                                          "uid": currentUser.uid,
                                          "fname": firstNameInputController.text,
                                          "surname": lastNameInputController.text,
                                          "email": emailInputController.text,
                                        })
                                        .then((result) => {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => HomePage(
                                                            title:
                                                              "Home",
                                                            uid: currentUser.uid,
                                                          )),
                                                  (_) => false),
                                              firstNameInputController.clear(),
                                              lastNameInputController.clear(),
                                              emailInputController.clear(),
                                              pwdInputController.clear(),
                                              confirmPwdInputController.clear()
                                            })
                                        .catchError((err) => print(err)))
                                    .catchError((err) => print(err));
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Error"),
                                        content: Text("The passwords do not match"),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text("Close"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    });
                              }
                            }
                          },
                        ),
                        )

                        ),

                      ],
                    ),
                  ),
                         

                  Container(
                        margin: EdgeInsets.only(top: 20),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: RichText( 
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,),
                              text: 'Already have an account? ',
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Click Here to login!',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,),
                                )
                              ],
                            ),
                          ),
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
}
