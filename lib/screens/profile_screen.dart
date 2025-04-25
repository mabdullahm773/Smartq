import 'dart:convert';

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
          Padding(
            padding: EdgeInsets.only(top: Height * 0.05),
            // for icon and edit button
            child: Stack(
              children: [
                file != null
                ? Center(
                  child: CircleAvatar(
                      radius: Width * 0.23,
                      backgroundImage : FileImage(file!)
                    ),
                )
                : Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: Height * 0.04),
                    child: CircularProgressIndicator(),
                  )
                ),
                Padding(
                  padding: EdgeInsets.only(top: Height * 0.18, left: Width * 0.27),
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        backgroundColor: Colors.grey
                      ),
                      onPressed: () {},
                      child: Icon(Icons.edit, color: Colors.black, size: Width * 0.05,)
                    ),
                  )
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Width * 0.15, vertical: Height * 0.05),
            child: TextField(
              // controller: _namecontroller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Height * 0.02)
                ),
              ),
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.done,
              maxLength: 30,
              maxLines: 1,
            ),
          )
        ]
      )
    );
  }
}
