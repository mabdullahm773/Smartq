import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:tappo/screens/home_screen.dart';
import 'package:tappo/screens/login_screen.dart';
import 'package:tappo/services/screen_size_service.dart';
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
    Future.delayed(Duration(milliseconds : 1500),(){
      _checkLoginStatus();
    });
    // TODO: implement initState
    super.initState();
  }

  Future <void> _checkLoginStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if(user != null){
      await UserManager().initialize(); // Load user data
      await checkUserData();  // Check if user exists in Firestore or create new
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    }
    else{
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0F2F1),
      body: Container(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: Height * 0.24,),
              Image.asset("assets/images/smartq_logo.png", scale: 3.2,),
              SizedBox(height: 8,),
              Text("SmartQ", style: TextStyle(fontSize: 18, color: Colors.teal.shade400, fontWeight: FontWeight.w600),),
              SizedBox(height: Height * 0.26,),
              SpinKitWave(
                color: Colors.teal.shade400,
                size: 55.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
