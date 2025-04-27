import 'dart:io';
import 'package:tappo/services/image_service.dart';
import 'package:flutter/material.dart';
import 'package:tappo/services/screen_size_service.dart';
import 'package:tappo/services/user_data_service.dart';
import 'package:tappo/widgets/custom_message.dart';
import 'package:tappo/widgets/loading_widget.dart';
import '../services/auth_service.dart';
import '../services/internet_service.dart';
import '../services/user_manager_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final userManager = UserManager();
  bool _updatedetail = false;
  File? file;
  TextEditingController _usernameController = TextEditingController(text: UserManager().name);
  TextEditingController _emailController = TextEditingController(text: UserManager().email);
  TextEditingController _createdAtController = TextEditingController(text: UserManager().getFormattedCreatedAt());
  @override
  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    await userManager.refreshProfileImage();
    setState(() {});
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
                  Center(
                    child: CircleAvatar(
                      radius: Width * 0.23,
                      backgroundImage: userManager.getProfileImageProvider(),
                    ),
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
                  hintText: UserManager().name,
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
                    if(value == UserManager().name)
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
                  hintText: UserManager().email,
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
                  hintText: UserManager().createdAt,
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
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if(_updatedetail) FloatingActionButton(
              onPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                showLoadingDialog(context);
                String newname = _usernameController.text;
                if(await UserManager().updateUserName(newName : newname)){
                  hideLoadingDialog(context);
                  showDialog(
                    context: context,
                    builder: (context) => SuccessMessage(
                      title: "Success!",
                      description: "Your data has been saved successfully.",
                      onOkPressed: () => Navigator.pop(context),
                    ),
                  );
                  setState(() {
                    // close the keyboard
                    _updatedetail = false;
                  });
                }
                else{
                  hideLoadingDialog(context);
                  showDialog(
                      context: context,
                      builder: (context) => FailureMessage(
                        title: "Oops!",
                        description: "There was a network issue. Try again later.",
                        onOkPressed: () => Navigator.pop(context),
                      )
                  );
                  setState(() {
                    // close the keyboard
                    _updatedetail = false;
                  });
                }
              },
              child: Icon(Icons.save),
            ),
            SizedBox(
              height: 15,
            ),
            FloatingActionButton(
              onPressed: (){
                signOutWithGoogle();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Icon(Icons.logout),
            ),
          ],
        )
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
