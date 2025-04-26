import 'dart:io';
import 'package:tappo/services/image_service.dart';
import 'package:tappo/widgets/floating_button.dart';

import '../services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:tappo/screens/login_screen.dart';
import 'package:tappo/services/screen_size_service.dart';
import 'package:tappo/services/firebase_data_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _updatedetail = false;
  File? file;
  TextEditingController _usernameController = TextEditingController(text: uname);
  TextEditingController _emailController = TextEditingController(text: uemail);
  TextEditingController _createdAtController = TextEditingController(text: ucreatedAt);
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
                          onPressed: () => _showImageEditingDialogue(context),

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
                onChanged: (value){
                  setState(() {
                    if(value == uname)
                      _updatedetail = false;
                    else
                        _updatedetail = true;
                  });
                },
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
            Padding(
              padding: EdgeInsets.only(left: Width * 0.15, right: Width * 0.15, top: Height * 0.035),
              // for email
              child: TextField(
                readOnly: true,
                controller: _createdAtController,
                decoration: InputDecoration(
                  counterText : "",
                  labelText : "Id Created At ",
                  hintText: ucreatedAt,
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
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButtons(showsecondbutton: _updatedetail),
            )
          ]
        ),
      ),
      // floatingActionButton: Positioned(
      //   bottom: Height * 0.1,
      //   right:  Width * 0.05,
      //   child: Row(
      //     children: [
      //       FloatingActionButton(
      //         backgroundColor: Colors.amberAccent,
      //         foregroundColor: Colors.red,
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(40)
      //         ),
      //         child: Icon(Icons.logout_rounded, size: 28),
      //         onPressed: (){
      //           signOutWithGoogle();
      //           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      //         }
      //       ),
      //       Visibility(
      //         visible: _updatedetail,
      //         child: FloatingActionButton(
      //           backgroundColor: Colors.amberAccent,
      //           foregroundColor: Colors.red,
      //           shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(40)
      //           ),
      //           child: Icon(Icons.logout_rounded, size: 28),
      //           onPressed: (){
      //             signOutWithGoogle();
      //             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      //           }
      //         )
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}

_showImageEditingDialogue(context){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Choose the Source'),
            IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close))
          ],
        ),
        content: SingleChildScrollView(  // Wrap content in scroll view or fixed size
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  IconButton(onPressed: () => accessCamera(),
                      icon: Icon(Icons.camera),
                  ),
                  Text("Camera")
                ],
              ),
              Column(
                children: [
                  IconButton(onPressed: () => accessGallery(),
                    icon: Icon(Icons.browse_gallery),
                  ),
                  Text("Gallery")
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
