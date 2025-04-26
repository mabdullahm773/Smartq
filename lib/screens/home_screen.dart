import 'package:flutter/material.dart';
import 'package:tappo/screens/login_screen.dart';
import 'package:tappo/screens/profile_screen.dart';
import 'package:tappo/services/auth_service.dart';
import 'package:tappo/services/firebase_data_service.dart';
import 'package:tappo/services/user_manager_service.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: (){
              displaydebug();
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
            child: Text("Profile Page")
          ),
          ElevatedButton(
              onPressed: (){
                signOutWithGoogle();
                UserManager().signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text("Sign Out")
          ),
        ],
      ),
    );
  }
}
