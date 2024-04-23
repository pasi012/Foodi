import 'package:admin_web_portal/authentication/Screens/Welcome/welcome_screen.dart';
import 'package:admin_web_portal/mainScreens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'authentication/constants.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Admin Web Portal",
      home: FirebaseAuth.instance.currentUser == null
          ? const WelcomeScreen()
          : const HomeScreen(),
    );
  }
}
