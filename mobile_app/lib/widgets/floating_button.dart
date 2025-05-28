import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../services/auth_service.dart';

class FloatingActionButtons extends StatelessWidget {
  final bool showsecondbutton;

  const FloatingActionButtons({required this.showsecondbutton});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if(showsecondbutton) FloatingActionButton(onPressed: (){},
            child: Icon(Icons.save),
          ),
          FloatingActionButton(
            onPressed: (){
              signOutWithGoogle();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: Icon(Icons.logout),
          ),
        ],
      );
  }
}
