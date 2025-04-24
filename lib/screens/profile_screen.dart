import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:tappo/services/local_storage_service.dart';
import 'package:tappo/services/screen_size_service.dart';




class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? file;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    // Wait for SharedPreferences to load
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('user_profile');

    if (path != null) {
      setState(() {
        file = File(path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          file != null
              ? Center(
                child: Padding(
                  padding: EdgeInsets.only(top: Height * 0.04),
                  child: CircleAvatar(
                      radius: Width * 0.23,
                      backgroundImage : FileImage(file!)
                  ),
                ),
              )
              : Center(child: CircularProgressIndicator()),
        ],
      )
    );
  }
}
