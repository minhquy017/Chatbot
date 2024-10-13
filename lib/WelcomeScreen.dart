import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chat_bot_flutter/SignUpScreen.dart';
import 'package:chat_bot_flutter/LoginScreen.dart';
class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 300,
            ),
            SizedBox(height: 50),
            Text(
              'Welcome to',
              style: TextStyle(
                  fontFamily: 'Poppins',
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Gcares 👋',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4E0189),
              ),
            ),
            SizedBox(height: 50),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4E0189),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0), // Bo tròn góc
                ),
                padding: EdgeInsets.symmetric(horizontal: 180, vertical: 20), // Điều chỉnh kích thước nút
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ),
            SizedBox(height: 20),

            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 170, vertical: 20),
                side: BorderSide(color: Color(0xFF4E0189), width: 2.0),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: Text(
                'Sign up',
                style: TextStyle(fontSize: 18),
              ),
            ),

            SizedBox(height: 30),
            Text('Or with',
              style: TextStyle(
                color: Color(0xFF999EA1),
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 20),
            // Row containing the individual buttons for each icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 15),
                _buildSocialButton(FaIcon(FontAwesomeIcons.google, color: Color(0xFF4285F4)), () {
                  print('Google button pressed');
                }, width: 130),
                SizedBox(width:15), // Space between buttons
                _buildSocialButton(Icon(Icons.apple, color: Colors.black), () {
                  print('Apple button pressed');
                }, width: 130),
                SizedBox(width: 15), // Space between buttons
                _buildSocialButton(Icon(Icons.facebook, color: Colors.blue), () {
                  print('Facebook button pressed');
                }, width: 130),
              ],
            ),
            SizedBox(height: 20),
            Text('By continuing, you agree to our',
              style: TextStyle(
                color: Color(0xFF999EA1),
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text('User Agreement and Privacy Policy',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  // Method to build a social button with specific width
  Widget _buildSocialButton(Widget icon, VoidCallback onPressed, {required double width}) {
    return SizedBox(
      width: width, // Sử dụng SizedBox để cố định chiều rộng
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0), // Bo tròn góc
          ),
          padding: EdgeInsets.symmetric(vertical: 15), // Điều chỉnh chiều cao
          side: BorderSide(color: Color(0xFFE3E3E3), width: 2.0),
        ),
        onPressed: onPressed,
        child: icon, // Không đặt màu để giữ nguyên màu gốc
      ),
    );
  }
}
