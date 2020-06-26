import 'dart:io'; 
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart'; 
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  TextEditingController emailInputController;
  TextEditingController phoneInputController;

  final FirebaseAuth auth = FirebaseAuth.instance;
  File _image;    
  String _uploadedFileURL;  

  @override
  initState() {
    firstNameInputController = new TextEditingController();
    lastNameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    phoneInputController = new TextEditingController();
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

  String phoneValidator(String value) {
    if (value.length < 13) {
      return 'Phone must be longer than 10 digits';
    } else {
      return null;
    }
  }

  void inputData() async {
        final FirebaseUser user = await auth.currentUser();
        Firestore.instance
        .collection("users")
        .document(user.uid)
        .updateData({
            "uid": user.uid,
            "fname": firstNameInputController.text,
            "surname": lastNameInputController.text,
            "email": emailInputController.text,
            "phone" : phoneInputController.text,
            "photo" : _uploadedFileURL,
        })
      .then((result) => {
        Navigator.pop(context),
        firstNameInputController.clear(),
        lastNameInputController.clear(),
        emailInputController.clear(),
        phoneInputController.clear(),
      })
      .catchError((err) => print(err))
      .catchError((err) => print(err));
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
                      "EDIT PROFILE", style: TextStyle(fontWeight: FontWeight.bold),
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
                        padding: const EdgeInsets.all(1.0),
                        child: Text('Selected Image'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                        children: <Widget>[
                          _image != null    
                              ? Image.asset(    
                                  _image.path,    
                                  height: 60,    
                                )    
                              : Container(height: 60),    
                          _image == null    
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ButtonTheme(
                                    minWidth: 100.0,
                                    height: 30.0,
                                    child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    

                                    ),
                                  child: Text("Choose File",
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold )
                                    ),
                                  color: Color(0xffFBB034),
                                  textColor: Colors.white,
                                  
                                  onPressed: () {
                                    setState(() {
                                      chooseFile();
                                    });
                                    } 
                                    ),  
                                    )
                             ) : Container(),    
                          // _image != null    
                          //     ? RaisedButton(    
                          //         child: Text('Upload File'),    
                          //         onPressed: uploadFile,    
                          //         color: Colors.cyan,    
                          //       )    
                          //     : Container(),    
                          _image != null    
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ButtonTheme(
                                    minWidth: 100.0,
                                    height: 30.0,
                                    child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),

                                    ),
                                  child: Text("Clear Selection",
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold )
                                    ),
                                  color: Color(0xffFBB034),
                                  textColor: Colors.white,
                                  
                                  onPressed: () {
                                    setState(() {
                                      clearSelection();
                                    });
                                    
                                    } 
                                    ),  
                                    )
                             ) : Container(),   

                          ],
                        ),
                      ),
                      

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
                              prefixIcon: Icon(Icons.phone),
                              labelText: 'Phone',
                            ),
                            controller: phoneInputController,
                            validator: phoneValidator,
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
                              
                              if(_image!=null){

                              uploadFile();

                              //inputData();
                              } else{
                                  Fluttertoast.showToast(
                                  msg: "Pease select an image!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                              }
                              
                            }
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

Future chooseFile() async {    
   await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {    
     setState(() {    
       _image = image;    
     });    
   });    
 }

 Future uploadFile() async {    
   StorageReference storageReference = FirebaseStorage.instance    
       .ref()    
       .child('users/${Path.basename(_image.path)}');    
   StorageUploadTask uploadTask = storageReference.putFile(_image);    
   await uploadTask.onComplete;    
   print('File Uploaded');    
   storageReference.getDownloadURL().then((fileURL) {    
     setState(() {    
       _uploadedFileURL = fileURL;
       
       
       inputData();  


     });    
   });    
 }  

   void clearSelection() {
    setState(() {
      _image = null;
      _uploadedFileURL = null;
    });
  }

}
