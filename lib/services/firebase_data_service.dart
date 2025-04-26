import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tappo/services/internet_service.dart';

late User user;
late String uname;
late String uemail;
late String ucreatedAt;
File? photoFile;

Future<void> fetchUserData() async {
  print("@@@@@@@@@@@           FETCHING USER DATA");
  user = FirebaseAuth.instance.currentUser!;
  uname = user.displayName!;
  uemail = user.email!;
  // for image and created at
  print("@@@@@@@@@@@           FETCHING USER DATA DONE");
  print("@@@@@@@@@@@           FETCHING LOCAL DATA");

  fetchLocalData();

  print("@@@@@@@@@@@           FETCHING USER DATA");
  print("@@@@@@@@@@@           FETCHING USER DATA DONE");

}

Future<void> fetchLocalData() async {
  try {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve createdAt
    ucreatedAt = prefs.getString('createdAt_${user.uid}') ?? "Not Found";
    // if createdAT not found then check internet and fetch it from the firebase
    if(ucreatedAt == "Not Found" && await checkInternetConnection()){
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      userDoc.get('createdAt');
      await saveLocalData();

    }
    // Retrieve photo
    String? photoPath = prefs.getString('photoPath_${user.uid}');
    photoFile = photoPath != null ? File(photoPath) : null;

  } catch (e) {
    print('Error fetching local data: $e');
  }
}
Future<void> saveLocalData() async {
  try {
    final prefs = await SharedPreferences.getInstance();

    // Save createdAt
    await prefs.setString('createdAt_${user.uid}', ucreatedAt);

    // Save photo
    if (user.photoURL != null && user.photoURL!.isNotEmpty) {
      final response = await http.get(Uri.parse(user.photoURL!));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/${user.uid}-profile.jpg';

        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        await prefs.setString('photoPath_${user.uid}', filePath);

      } else {
      }
    }
  } catch (e) {
  }
}



// ONLY FOR DEBUGGING
void displaydebug(){
  user = FirebaseAuth.instance.currentUser!;
  print('User UID: ${user?.uid}');

}