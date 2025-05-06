import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
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


Future<bool> deleteUserAndData() async {
  try {
    final userManager = UserManager();
    final uid = userManager.uid;

    if (uid.isEmpty) return false;

    final userDocRef = FirebaseFirestore.instance.collection('users').doc(uid);

    // 1. Delete all documents inside 'devices' subcollection
    final devicesCollection = userDocRef.collection('devices');
    final deviceDocs = await devicesCollection.get();
    for (var doc in deviceDocs.docs) {
      await doc.reference.delete();
    }

    // 2. Delete user document from Firestore
    await userDocRef.delete();

    // 3. Delete from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${uid}_name');
    await prefs.remove('${uid}_email');
    await prefs.remove('${uid}_photoURL');
    await prefs.remove('${uid}_createdAt');
    await prefs.remove('${uid}_localProfileImagePath');

    // 4. Delete the locally saved profile image file
    final profileImageFile = await userManager.getLocalProfileImage();
    if (profileImageFile != null && await profileImageFile.exists()) {
      await profileImageFile.delete();
      print('Local profile image deleted.');
    }

    print('User and all related data (Firestore + SharedPreferences + local image) deleted.');
    return true;
  } catch (e) {
    print('Error deleting user and data: $e');
    return false;
  }
}

