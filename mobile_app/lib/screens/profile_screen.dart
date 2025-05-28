import 'dart:io';
import 'package:tappo/services/image_service.dart';
import 'package:flutter/material.dart';
import 'package:tappo/services/screen_size_service.dart';
import 'package:tappo/services/user_data_service.dart';
import 'package:tappo/widgets/confirmation_message.dart';
import 'package:tappo/widgets/custom_pop_message.dart';
import 'package:tappo/widgets/loading_widget.dart';
import '../api/api_connectivity.dart';
import '../services/auth_service.dart';
import '../services/user_manager_service.dart';
import '../widgets/appbar_widget.dart';
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
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _floatingUpdateButton()async {
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
  }

  Future<void> _loadProfileImage() async {
    await userManager.refreshProfileImage();
    setState(() {});
  }

  Future<void> _showEditIpPortDialog() async {
    TextEditingController controller = TextEditingController(text: ipAndPort);

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit IP and Port', style: TextStyle(color: Colors.teal),),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'IP and Port',
              hintText: 'e.g. 192.168.100.11:5099',
              labelStyle: TextStyle(color: Colors.teal, fontSize: 16),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.text,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.red),),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Save', style: TextStyle(color: Colors.green),),
              onPressed: () {
                setState(() {
                  ipAndPort = controller.text.trim();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8E8D2),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomAppBar(Title: "Profile", BackButton: true, ProfileIcon: false,),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: Height * 0.05),
                    // for icon and edit button
                    child: Stack(
                      children: [
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.tealAccent, width: 3),
                              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))],
                            ),
                            child: CircleAvatar(
                              radius: Width * 0.23,
                              backgroundImage: userManager.getProfileImageProvider(),
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: Height * 0.18, left: Width * 0.27),
                          child: Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                backgroundColor: Colors.tealAccent
                              ),
                                onPressed: () => _showImageEditingDialogue(context),
                                child: Icon(Icons.edit, color: Colors.black, size: Width * 0.05,)
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                  // username
                  Padding(
                    padding: EdgeInsets.only(
                      left: Width * 0.15,
                      right: Width * 0.15,
                      top: Height * 0.04,
                    ),
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        counterText: "",
                        labelText: " Username",
                        labelStyle: TextStyle(fontSize: 15, color: Colors.black),
                        hintText: UserManager().name.isNotEmpty ? UserManager().name : "Enter your username",
                        prefixIcon: Icon(Icons.person_outline, color: Colors.teal),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Height * 0.02),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Height * 0.02),
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Height * 0.08),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.done,
                      maxLength: 30,
                      maxLines: 1,
                      style: TextStyle(fontSize: 17, color: Colors.black87),
                      onChanged: (value) {
                        setState(() {
                          _updatedetail = (value != UserManager().name);
                        });
                      },
                    ),
                  ),
                  // email
                  Padding(
                    padding: EdgeInsets.only(left: Width * 0.15, right: Width * 0.15, top: Height * 0.02),
                    // for email
                    child: TextField(
                      readOnly: true,
                      controller: _emailController,
                      decoration: InputDecoration(
                        counterText : "",
                        labelText : " Email ",
                        hintText: UserManager().email.isNotEmpty ? UserManager().email : "No Email Found X",
                        prefixIcon: Icon(Icons.email, color: Colors.teal),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Height * 0.02),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Height * 0.02),
                          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Height * 0.08),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.done,
                      maxLength: 30,
                      maxLines: 1,
                    ),
                  ),
                  // created at
                  Padding(
                    padding: EdgeInsets.only(left: Width * 0.15, right: Width * 0.15, top: Height * 0.02),
                    // for email
                    child: TextField(
                      readOnly: true,
                      controller: _createdAtController,
                      decoration: InputDecoration(
                        counterText : "",
                        labelText : " Id Created At ",
                        hintText: UserManager().createdAt!.isNotEmpty ? UserManager().createdAt : "Not Found",
                        prefixIcon: Icon(Icons.date_range, color: Colors.teal),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Height * 0.02),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Height * 0.02),
                          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Height * 0.08),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.done,
                      maxLength: 30,
                      maxLines: 1,
                    ),
                  ),
                  // api button
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: _showEditIpPortDialog,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text('Edit Api URL',  style: TextStyle(color: Colors.teal, fontSize: 16),),
                      ),
                    ),
                  ),
                ]
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              '© 2025 SmartQ. Making smart living simple..',
              style: TextStyle(
                fontSize: 12,
                color: Colors.teal.shade700,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // saving button
            if(_updatedetail) FloatingActionButton(
              onPressed: () async => await _floatingUpdateButton(),
              child: Icon(Icons.save, color: Colors.green, size: 28,),
              shape: CircleBorder(),
              backgroundColor: Colors.white,
            ),
            SizedBox(
              height: 15,
            ),
            // deleting button
            FloatingActionButton(
              onPressed: () async {
                showDialog(context: context,
                    builder: (_) => ConfirmationMessage(
                      title: "Confirm Deletion",
                      description: "This will remove all the data from your account permanently. ",
                      yesText: "Confirm",
                      noText: "Back",
                      onYesPressed: () {
                          Navigator.pop(context);
                          _handleDeletion(context);
                      },
                      onNoPressed: () => Navigator.pop(context)
                    )
                );
              },
              child: Icon(Icons.delete, color: Colors.red, size: 28,),
              shape: CircleBorder(),
              backgroundColor: Colors.white,
            ),
            SizedBox(
              height: 15,
            ),
            // logout button
            FloatingActionButton(
              onPressed: (){
                signOutWithGoogle();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Icon(Icons.logout, color: Colors.red, size: 28,),
              shape: CircleBorder(),
              backgroundColor: Colors.white,
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

_handleDeletion(context) async {
  showLoadingDialog(context);
  if(await deleteUserAndData()){
    hideLoadingDialog(context);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => SuccessMessage(
            title: "Success", description: "Your account has been successfully deleted.",
            onOkPressed: (){
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen())
              );
            }
        )
    );
  } else{
    hideLoadingDialog(context);
    showDialog(
        context: context,
        builder: (context) => FailureMessage(title: "Failed", description: "Account deletion failed. Please try again later", onOkPressed: () =>Navigator.pop(context))
    );
  }
}



