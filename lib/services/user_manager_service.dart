import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tappo/services/user_data_service.dart';

class UserManager {
  static final UserManager _instance = UserManager._internal();

  late User user;
  late String name;
  late String email;
  late String uid;
  String? photoUrl;
  String? createdAt;
  File? profileImage;

  factory UserManager() {
    return _instance;
  }

  UserManager._internal();


  Future<bool> initialize() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // No user logged in
      return false;
    }

    // Set the current user to UserManager's user field
    user = currentUser;
    name = user.displayName ?? '';
    email = user.email ?? '';
    uid = user.uid;
    photoUrl = user.photoURL;

    // Call loadUserData to load any additional data (like createdAt) from local storage or Firestore
    await loadUserData();

    return true;
  }

  ImageProvider getProfileImageProvider() {
    if (profileImage != null) {
      return FileImage(profileImage!);
    } else if (photoUrl != null && photoUrl!.isNotEmpty) {
      return NetworkImage(photoUrl!);
    } else {
      // Fallback to a default asset image or placeholder
      return AssetImage('assets/images/default_profile.png');
    }
  }

  String getFormattedCreatedAt() {
    if (createdAt != null && createdAt!.isNotEmpty) {
      try {
        final date = DateTime.parse(createdAt!);
        return DateFormat('MMMM dd, yyyy').format(date); // Example: April 27, 2025
      } catch (e) {
        return createdAt!; // If parsing fails, return raw
      }
    } else {
      return 'Not Available';
    }
  }


  // This function checks and loads user data from Firestore and stores it in SharedPreferences
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if data exists in SharedPreferences
    final savedName = prefs.getString('${uid}_name');
    final savedEmail = prefs.getString('${uid}_email');
    final savedPhotoUrl = prefs.getString('${uid}_photoURL');
    final savedCreatedAt = prefs.getString('${uid}_createdAt');


    if (savedName == null || savedEmail == null || savedPhotoUrl == null || savedCreatedAt == null) {
      // Data is not found in SharedPreferences, so fetch it from Firestore
      await _fetchAndStoreUserDataFromFirestore(prefs);
    } else {
      // Data is already available in SharedPreferences, use it
      name = savedName;
      email = savedEmail;
      photoUrl = savedPhotoUrl;
      createdAt = savedCreatedAt;

      // 👇 Load the local profile image
      profileImage = await getLocalProfileImage();
    }
  }

  Future<File?> getLocalProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('${uid}_localProfileImagePath');
    if (path != null && await File(path).exists()) {
      return File(path);
    }
    return null; // No local file found
  }

  // This function fetches user data from Firestore and stores it in SharedPreferences
  Future<void> _fetchAndStoreUserDataFromFirestore(SharedPreferences prefs) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final fetchedName = userDoc.get('name');
        final fetchedEmail = userDoc.get('email');
        final fetchedPhotoUrl = userDoc.get('photoURL');
        final fetchedCreatedAt = userDoc.get('createdAt');

        // Store fetched data in SharedPreferences
        await prefs.setString('${uid}_name', fetchedName);
        await prefs.setString('${uid}_email', fetchedEmail);
        await prefs.setString('${uid}_photoURL', fetchedPhotoUrl);
        await prefs.setString('${uid}_createdAt', fetchedCreatedAt);


        // Also update the local fields
        name = fetchedName;
        email = fetchedEmail;
        photoUrl = fetchedPhotoUrl;
        createdAt = fetchedCreatedAt;

        // 👇 NEW: Download the image and store it locally
        if (fetchedPhotoUrl != null && fetchedPhotoUrl.isNotEmpty) {
          await downloadAndSaveUserProfileImage(fetchedPhotoUrl);
        }
      }
    } catch (e) {
      print("Error fetching user data from Firestore: $e");
    }
  }

  Future<void> downloadAndSaveUserProfileImage(String photoUrl) async {
    try {
      // Get the app's documents directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$uid-profile.jpg';

      // Download the image from the photoURL
      final response = await http.get(Uri.parse(photoUrl));
      if (response.statusCode == 200) {
        // Save the image locally
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Save the local file path in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('${uid}_localProfileImagePath', filePath);


        // 👇 IMMEDIATELY load the image into a variable
        profileImage = file;

        print('Profile image downloaded and saved to: $filePath');
      } else {
        print('Failed to download profile image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading profile image: $e');
    }
  }

  Future<void> refreshProfileImage() async {
    profileImage = await getLocalProfileImage();
  }

  void signOut() {
    name = '';
    email = '';
    uid = '';
    photoUrl = null;
    createdAt = null;
  }
}
