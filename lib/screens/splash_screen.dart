import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tappo/screens/home_screen.dart';
import 'package:tappo/screens/login_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import '../services/auth_service.dart';
import '../services/firebase_data_service.dart';
import '../services/screen_size_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Future <void> _checkstatus() async {
    if(await checkLoginStatus()){

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
    else{
      // print("@@@@@@@@@@@           NOT LOGGED IN");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }
  void initState() {
    Future.delayed(Duration(seconds : 2),(){
      _checkstatus();
    });

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      body: Center(
        child: Lottie.asset(
            'assets/animations/splash.json',
            width: 500,
            fit: BoxFit.contain
        ),
      )
    );
  }
}
