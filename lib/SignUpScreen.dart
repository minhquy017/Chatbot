import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart'; // Thêm thư viện Firebase Realtime Database
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool agreeToTerms = false;
  bool isPasswordVisible = false;

  final DatabaseReference _database = FirebaseDatabase.instance.ref(); // Khởi tạo DatabaseReference

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Poppins'),
          bodyMedium: TextStyle(fontFamily: 'Poppins'),
          bodySmall: TextStyle(fontFamily: 'Poppins'),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sign Up'),
          backgroundColor: Color(0xFF4E0189),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hello there 👋',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Please enter your email & password to create an account',
                  style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                ),
              ),
              SizedBox(height: 30),

              // Nhãn Email và nút Email
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                ),
              ),
              SizedBox(height: 5),
              _buildRoundedButton(
                controller: emailController,
                label: 'Email',
                isPassword: false,
              ),
              SizedBox(height: 20),

              // Nhãn Password và nút Password
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                ),
              ),
              SizedBox(height: 5),
              _buildRoundedButton(
                controller: passwordController,
                label: 'Password',
                isPassword: true,
              ),
              SizedBox(height: 20),

              Row(
                children: [
                  Checkbox(
                    value: agreeToTerms,
                    onChanged: (bool? value) {
                      setState(() {
                        agreeToTerms = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      'I Agree to the Terms, Conditions & the Privacy Policy',
                      style: TextStyle(fontSize: 12, fontFamily: 'Poppins'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _signUp();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4E0189),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 150, vertical: 15),
                ),
                child: Text('Sign Up', style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'Poppins')),
              ),
              SizedBox(height: 30),
              Text(
                'Or With',
                style: TextStyle(
                  color: Color(0xFF999EA1),
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 20),
              // Row chứa các nút xã hội
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 15),
                  _buildSocialButton(FaIcon(FontAwesomeIcons.google, color: Color(0xFF4285F4)), () {
                    print('Google button pressed');
                  }, width: 120),
                  SizedBox(width: 15),
                  _buildSocialButton(Icon(Icons.apple, color: Colors.black), () {
                    print('Apple button pressed');
                  }, width: 120),
                  SizedBox(width: 15),
                  _buildSocialButton(Icon(Icons.facebook, color: Colors.blue), () {
                    print('Facebook button pressed');
                  }, width: 120),
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? ', style: TextStyle(fontFamily: 'Poppins')),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/Login');
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Color(0xFF4E0189), fontFamily: 'Poppins'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Phương thức để thực hiện đăng ký người dùng với Firebase
  Future<void> _signUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Lưu thông tin người dùng vào Realtime Database
      await _database.child("users").child(userCredential.user!.uid).set({
        'email': emailController.text,
        'createdAt': DateTime.now().toString(),
      });

      // Hiển thị thông báo đăng ký thành công
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Sign Up Successful!'),
          );
        },
      );

      // Chuyển sang màn hình LoginScreen sau 2 giây
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, '/Login');
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else {
        errorMessage = 'Failed to sign up. Please try again.';
      }

      // Hiển thị thông báo lỗi
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
          );
        },
      );
    }
  }

  // Phương thức để xây dựng nút xã hội với chiều rộng cụ thể
  Widget _buildSocialButton(Widget icon, VoidCallback onPressed, {required double width}) {
    return SizedBox(
      width: width,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: EdgeInsets.symmetric(vertical: 15),
          side: BorderSide(color: Color(0xFFE3E3E3), width: 2.0),
        ),
        onPressed: onPressed,
        child: icon,
      ),
    );
  }

  // Phương thức để xây dựng nút cho Email và Password với độ bo tròn và màu viền
  Widget _buildRoundedButton({
    required TextEditingController controller,
    required String label,
    required bool isPassword,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontFamily: 'Poppins'),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Color(0xFFC6C6C6), width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Color(0xFFC6C6C6), width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Color(0xFF4E0189), width: 2.0),
        ),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
        )
            : null,
      ),
      style: TextStyle(fontFamily: 'Poppins'),
    );
  }
}
