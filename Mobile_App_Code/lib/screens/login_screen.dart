import 'package:flutter/material.dart';
import 'package:tappo/screens/home_screen.dart';
import 'package:tappo/services/auth_service.dart';
import 'package:tappo/widgets/loading_widget.dart';
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
      backgroundColor: Color(0xFFE0F2F1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  right: _animate ? Width * 0.22 : Width * -0.2,
                  bottom: Height * 0.45,
                  child: Column(
                    children: [
                      Image.asset("assets/images/smartq_logo.png", width: Width * 0.4,),
                      // Icon(Icons.lock_outline, size: 80, color: Colors.deepPurple),
                      SizedBox(height: 20),
                      SizedBox(height: 30,),
                      Text('Welcome To Smartq', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.teal.shade400),),
                    ],
                  )
                ),
                Positioned(
                  bottom: Height * 0.2,
                  left: Width * 0.18,
                  child: ElevatedButton(
                    onPressed: _handleSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal.shade400,
                      padding: EdgeInsets.symmetric(vertical: Height * 0.008, horizontal: Width * 0.01),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 18, right: 18, top: 2, bottom: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Sign In with Google", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),),
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
              '© 2025 SmartQ. Making smart living simple..',
              style: TextStyle(
                fontSize: 12,
                color: Colors.teal.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



