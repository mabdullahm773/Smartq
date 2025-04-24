import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tappo/services/firestore_service.dart';

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
    await checkUserData(user!);
    print("Login Successfull");
    // Once signed in, return the UserCredential
    //return await FirebaseAuth.instance.signInWithCredential(credential);
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