import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String name;
String email;
String imageUrl;

Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final FirebaseUser user = (await _auth.signInWithCredential(credential));

  // Checking if email and name is null
  assert(user.email != null);
  assert(user.displayName != null);
  assert(user.photoUrl != null);

  name = user.displayName;
  email = user.email;
  imageUrl = user.photoUrl;

  // Only taking the first part of the name, i.e., First Name
  if (name.contains(" ")) {
    name = name.substring(0, name.indexOf(" "));
  }

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

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
                  "photo": "Update in Edit Profile",
                }).then((_) {
                  print("google database success!");
                  // return 'signInWithGoogle succeeded: $user';
                })
              }
          });
}

void signOutGoogle() async {
  await googleSignIn.signOut();

  print("User Sign Out");
}
