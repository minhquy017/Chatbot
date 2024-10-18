import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Realtime Database
import 'package:chat_bot_flutter/SplashScreen.dart';
import 'package:chat_bot_flutter/WelcomeScreen.dart';
import 'package:chat_bot_flutter/SignUpScreen.dart';
import 'package:chat_bot_flutter/LoginScreen.dart';
import 'package:chat_bot_flutter/HomeChatScreen.dart';
import 'package:chat_bot_flutter/ResetPasswordScreen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo rằng các widget đã được khởi tạo
  await Firebase.initializeApp(); // Khởi tạo Firebase
  // Khởi tạo Firebase Realtime Database
  final databaseReference = FirebaseDatabase.instance.reference();


  runApp(MyApp());
}

extension on FirebaseDatabase {
  reference() {}
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Tắt banner debug
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/Welcome': (context) => WelcomeScreen(),
        '/SignUp': (context) => SignUpScreen(),
        '/Login': (context) => LoginScreen(),
        '/HomeChat':(contet) => HomeChatScreen(),
        '/reset-password':(context) => ResetPasswordScreen(),
      },
    );
  }
}
