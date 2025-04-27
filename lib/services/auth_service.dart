import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<bool> signInWithGoogle() async {
  try {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      // If user cancels the sign-in, return false
      return false;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    User? user = userCredential.user;

    if (user != null) {
      print("Login Successful");
      return true;  // Return true if login is successful
    } else {
      return false;  // Return false if no user is found
    }
  } catch (e) {
    print("An Error Occurred: $e");
    return false;  // Return false if there's an error
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

