import 'package:flutter/material.dart';
import 'package:tappo/screens/home_screen.dart';
import 'package:tappo/services/auth_service.dart';
import '../services/local_storage_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            ElevatedButton(child: Text("SIGN IN"), onPressed: () {
              signInWithGoogle();
              fetchUserData();
            }),
            ElevatedButton(child: Text("SIGN OUT"), onPressed: () => signOutWithGoogle()),
            ElevatedButton(child: Text("Profile Page"), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()))),
          ],
        ),
      ),
    );
  }
}
