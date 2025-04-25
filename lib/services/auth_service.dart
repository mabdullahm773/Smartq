import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'local_storage_service.dart';

Future<bool> checkLoginStatus() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) // User is logged in
    return true;
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
    await checkUserData(user!);
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

Future<void> checkUserData(User user) async {
  try{
    // fetch data from firestore
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    // check if there is some ref or not for the uid
    final doc = await userRef.get();

    if(!doc.exists){
      await userRef.set({
        'name' : user.displayName,
        'email' : user.email,
        'photoURL' : user.photoURL,
        'createdAt' : FieldValue.serverTimestamp(),
      });
      await savingDataLocally(user);
    }
    else {
      print("User ${user.displayName} Already Exists");
    }
  }
  catch(e){
    print("An error Occurred ${e}");
  }
}