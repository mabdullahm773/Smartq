import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tappo/screens/home_screen.dart';
import 'package:tappo/screens/login_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import '../services/auth_service.dart';
import '../services/firebase_data_service.dart';
import '../services/screen_size_service.dart';
import '../services/user_data_service.dart';
import '../services/user_manager_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds : 2500),(){
      print("@@@@@@@@@@                   checking login status start");
      _checkLoginStatus();
    });
    // TODO: implement initState
    super.initState();
  }

  Future <void> _checkLoginStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if(user != null){
      print("@@@@@@@@@@                   user is not null 1");
      await UserManager().initialize(); // Load user data
      print("@@@@@@@@@@                   user is not null 2");
      await checkUserData();  // Check if user exists in Firestore or create new
      print("@@@@@@@@@@                   user is not null  3");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    }
    else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Transform.scale(
          scale: 1.4, // Adjust this value as needed
          child: Lottie.asset(
            'assets/animations/splashscreen.json',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
