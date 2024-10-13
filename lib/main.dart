import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:chat_bot_flutter/SplashScreen.dart';
import 'package:chat_bot_flutter/WelcomeScreen.dart';
import 'package:chat_bot_flutter/SignUpScreen.dart';
import 'package:chat_bot_flutter/LoginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo rằng các widget đã được khởi tạo
  await Firebase.initializeApp(); // Khởi tạo Firebase
  runApp(MyApp());
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
      },
    );
  }
}
