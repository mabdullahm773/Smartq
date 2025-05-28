import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:tappo/screens/home_screen.dart';
import 'package:tappo/screens/login_screen.dart';
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
      backgroundColor: Colors.teal.shade50,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/smartq logo.png", scale: 5,),
              SizedBox(height: 5,),
              Text("SmartQ", style: TextStyle(fontSize: 18, color: Colors.teal.shade400, fontWeight: FontWeight.w600),),
              SizedBox(height: 30,),
              SpinKitWave(
                color: Colors.teal.shade200,
                size: 40.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
