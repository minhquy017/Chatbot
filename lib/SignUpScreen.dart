import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool agreeToTerms = false;
  bool isPasswordVisible = false; // Trạng thái hiển thị mật khẩu

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
              Navigator.pop(context); // Thực hiện hành động trở về
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
                    borderRadius: BorderRadius.circular(30.0), // Bo tròn góc
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 150, vertical: 15), // Điều chỉnh kích thước nút
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
                  SizedBox(width: 15), // Space between buttons
                  _buildSocialButton(Icon(Icons.apple, color: Colors.black), () {
                    print('Apple button pressed');
                  }, width: 120),
                  SizedBox(width: 15), // Space between buttons
                  _buildSocialButton(Icon(Icons.facebook, color: Colors.blue), () {
                    print('Facebook button pressed');
                  }, width: 120),
                ],
              ),
              Spacer(), // Đây là điểm quan trọng để đẩy phần bên dưới xuống
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
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

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
        labelStyle: TextStyle(fontFamily: 'Poppins'), // Thêm font Poppins vào label
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0), // Bo tròn góc
          borderSide: BorderSide(color: Color(0xFFC6C6C6), width: 2.0), // Màu viền và độ dày
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0), // Bo tròn góc
          borderSide: BorderSide(color: Color(0xFFC6C6C6), width: 2.0), // Màu viền và độ dày khi không được chọn
        ),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Color(0xFF999EA1),
          ),
          onPressed: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
        )
            : null,
      ),
    );
  }
}
