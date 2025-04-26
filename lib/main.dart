import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:tappo/firebase_options.dart";
import "package:tappo/screens/login_screen.dart";
import "package:tappo/screens/splash_screen.dart";
import "package:tappo/services/screen_size_service.dart";

Future<void> _FirebaseInitializing()async{
  // Ensure that Firebase is initialized before the app runs
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Initialize Firebase
  );
}

void main() async {
  await _FirebaseInitializing();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Update the screen size when the widget is built
    ScreenSizeScreen.updateSize(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
