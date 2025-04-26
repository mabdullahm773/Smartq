import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tappo/services/user_manager_service.dart';

Future<void> checkUserData() async {
  try{
    // fetch data from firestore
    final userRef = FirebaseFirestore.instance.collection('users').doc(UserManager().uid);
    // check if there is some ref or not for the uid
    final doc = await userRef.get();

    if(!doc.exists){
      await userRef.set({
        'name' : UserManager().name,
        'email' : UserManager().email,
        'photoURL' : UserManager().photoUrl,
        'createdAt' : UserManager().createdAt,
      });
    }
    else {
      print("User ${UserManager().name} Already Exists");
    }
  }
  catch(e){
    print("An error Occurred ${e}");
  }
}