import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tappo/screens/login_screen.dart';
import 'dart:io';
import 'package:tappo/services/screen_size_service.dart';
import 'package:tappo/services/local_storage_service.dart';

import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? file;
  TextEditingController _usernameController = TextEditingController(text: uname);
  TextEditingController _emailController = TextEditingController(text: uemail);
  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    //Map<String, dynamic> userData = await LocalStorageService.fetchUserData();
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
      body: SingleChildScrollView(
        child: Column(
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
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Your Title'),
                                  content: SingleChildScrollView(  // Wrap content in scroll view or fixed size
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,  // Important!
                                      children: [
                                        Text('Hello'),
                                        // your widgets here...
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(onPressed: () {}, child: Text('OK')),
                                  ],
                                );

                              },
                            );
                          },

                          child: Icon(Icons.edit, color: Colors.black, size: Width * 0.05,)
                      ),
                    )
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: Width * 0.15, right: Width * 0.15, top: Height * 0.08),
              // for username
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  counterText : "",
                  labelText : "Username ",
                  hintText: uname,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Height * 0.02),
                  ),
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.done,
                maxLength: 30,
                maxLines: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: Width * 0.15, right: Width * 0.15, top: Height * 0.035),
              // for email
              child: TextField(
                readOnly: true,
                controller: _emailController,
                decoration: InputDecoration(
                  counterText : "",
                  labelText : "Email ",
                  hintText: uemail,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Height * 0.02),
                  ),
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.done,
                maxLength: 30,
                maxLines: 1,
              ),
            ),
          ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amberAccent,
        foregroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40)
        ),
        child: Icon(Icons.logout_rounded, size: 28),
        onPressed: (){
          signOutWithGoogle();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
        }
      ),
    );
  }
}


_showImageEditingDialogue(context){
  showDialog(
    context: context,
    builder: (BuildContext context){
      return AlertDialog(
        title: Text("data"),
        content: Row(
          children: [
            ListTile()
          ],
        ),
      );
    }
  );
}