import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tappo/services/user_manager_service.dart';

Future<void> checkUserData() async {
  try{
    final userRef = FirebaseFirestore.instance.collection('users').doc(UserManager().uid);
    // check if there is some ref or not for the uid
    final doc = await userRef.get();
    // Get current device time
    final now = DateTime.now();
    // Format it the way you want
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);

    if(!doc.exists){
      await userRef.set({
        'name' : UserManager().name,
        'email' : UserManager().email,
        'photoURL' : UserManager().photoUrl,
        'createdAt' : formattedDate,
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