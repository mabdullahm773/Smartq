import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final localPath;

class LocalStorageService{

   static Future<void> savingDataLocally(User user) async {
     try {
       // 1. Download image from URL
       final response = await http.get(Uri.parse(user.photoURL!));

       if (response.statusCode == 200) {
         // 2. Get directory to save image
         final directory = await getApplicationDocumentsDirectory();
         final fileName = 'profile_${user.uid}.jpg';
         localPath = '${directory.path}/$fileName';

         // 3. Write image to file
         final localImage = File(localPath);
         await localImage.writeAsBytes(response.bodyBytes);

         // 4. Save info to SharedPreferences
         final prefs = await SharedPreferences.getInstance();
         await prefs.setString('user_name', user.displayName ?? '');
         await prefs.setString('user_email', user.email ?? '');
         await prefs.setString('user_profile', localPath);

         print('User data saved locally!');
       } else {
         print('Failed to download image');
       }
     } catch (e) {
       print('Error saving data: $e');
     }
   }
}
