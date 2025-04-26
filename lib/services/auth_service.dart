import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_data_service.dart';

User? user;

Future<bool> checkLoginStatus() async {
  user = FirebaseAuth.instance.currentUser;
  if (user != null)// User is logged in
  {
    return true;
  }
  else // User is NOT logged in
    return false;
}

Future<void> signInWithGoogle() async {
  try{
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if(googleUser == null){
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    User? user = userCredential.user;

    print("Login Successfull");
  }
  catch(e){
    print("An Error Ocurred : ${e}");
  }
}

Future<void> signOutWithGoogle() async {
  try{
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    print("Sign Out Successfull");
  }
  catch(e){
    print("An Error Ocurred : ${e}");
  }
}

