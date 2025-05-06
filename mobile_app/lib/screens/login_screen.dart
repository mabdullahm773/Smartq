import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tappo/screens/home_screen.dart';
import 'package:tappo/services/auth_service.dart';
import 'package:tappo/widgets/loading_widget.dart';
import '../services/firebase_data_service.dart';
import '../services/screen_size_service.dart';
import '../services/user_data_service.dart';
import '../services/user_manager_service.dart';
import '../widgets/custom_pop_message.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _animate = false;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(Duration(milliseconds: 200), () {setState(() {_animate = true;});});
  }

  Future<void> _handleSignIn() async {
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
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: Duration(seconds: 2),
                  curve: Curves.easeInOut,
                  right: _animate ? Width * 0.275 : Width * -0.2,
                  bottom: Height * 0.52,
                  child: Image.asset("assets/images/logo.png", width: Width * 0.4,),
                ),
                Positioned(
                  bottom: Height * 0.2,
                  left: Width * 0.18,
                  child: ElevatedButton(
                    onPressed: _handleSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFC900),
                      padding: EdgeInsets.symmetric(vertical: Height * 0.008, horizontal: Width * 0.01),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Sign In with Google", style: TextStyle(fontSize: 20),),
                          SizedBox(width: 15),
                          Image.asset("assets/images/google.png", height: 36),
                        ],
                      ),
                    ),
                  ),

                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              '© 2025 Tappo. Making smart living simple..',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



