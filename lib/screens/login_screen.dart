import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tappo/screens/home_screen.dart';
import 'package:tappo/services/auth_service.dart';
import 'package:tappo/widgets/loading_widget.dart';
import '../services/firebase_data_service.dart';
import '../services/screen_size_service.dart';
import '../services/user_data_service.dart';
import '../services/user_manager_service.dart';
import '../widgets/custom_message.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override

  bool _animate = false;

  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(Duration(milliseconds: 100), () {setState(() {_animate = true;});});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(seconds: 2),
            curve: Curves.easeInOut,
            right: _animate ? Width * 0.275 : Width * -0.2,
            bottom: Height * 0.55,
            child: Image.asset("assets/images/logo.png", width: Width * 0.4,),
          ),
          Positioned(
            bottom: Height * 0.25,
            right: Width * 0.25,
            child: ElevatedButton.icon(
                onPressed: () async {
                  showLoadingDialog(context);
                  if(await signInWithGoogle()){
                    await UserManager().initialize();  // Load user data
                    await checkUserData();  // Check if user exists in Firestore or create new
                    hideLoadingDialog(context);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }
                  else{
                    hideLoadingDialog(context);
                    showDialog(
                        context: context,
                        builder: (context) => SuccessMessage(
                          title: "Sign-In Failed!",
                          description: "Sign-in failed. Please try again..",
                          onOkPressed: () => Navigator.pop(context),
                        ),
                    );
                    hideLoadingDialog(context);
                  }
                },
                label: Text("Sign In With Google"),
                icon: Icon(Icons.login),
            ),
          ),
        ],
      ),
    );
  }
}
