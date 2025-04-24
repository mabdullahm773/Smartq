import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";


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
    }
    else{
        print("User ${user.displayName} Already Exists");
    }
  }
  catch(e){
print("An error Occurred ${e}");
  }
}

