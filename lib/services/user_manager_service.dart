import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserManager {
  static final UserManager _instance = UserManager._internal();

  late User user;
  late String name;
  late String email;
  late String uid;
  String? photoUrl;
  String? createdAt;

  factory UserManager() {
    return _instance;
  }

  UserManager._internal();

  Future<void> initialize() async {
    user = FirebaseAuth.instance.currentUser!;
    name = user.displayName ?? '';
    email = user.email ?? '';
    uid = user.uid;
    photoUrl = user.photoURL;

    await _loadOrFetchCreatedAt();
  }

  Future<void> _loadOrFetchCreatedAt() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCreatedAt = prefs.getString('createdAt_$uid');

    if (savedCreatedAt != null) {
      // Already saved locally
      createdAt = savedCreatedAt;
    } else {
      // Need to fetch from Firestore once
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final timestamp = userDoc.get('createdAt') as Timestamp;
      createdAt = timestamp.toDate().toIso8601String();  // converting to ISO string

      // Save it locally for future use
      await prefs.setString('createdAt_$uid', createdAt!);
    }
  }

  void signOut() {
    name = '';
    email = '';
    uid = '';
    photoUrl = null;
    createdAt = null;
  }
}
