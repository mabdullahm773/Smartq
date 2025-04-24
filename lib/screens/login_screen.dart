import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tappo/services/auth_service.dart';

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
            ElevatedButton(child: Text("SIGN IN"), onPressed: () => signInWithGoogle()),
            ElevatedButton(child: Text("SIGN OUT"), onPressed: () => signOutWithGoogle()),
          ],
        ),
      ),
    );
  }
}
