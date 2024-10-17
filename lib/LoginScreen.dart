
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Khởi tạo Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/chat': (context) => ChatScreen(), // Thay ChatScreen bằng màn hình chat của bạn
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool rememberMe = false; // Quản lý trạng thái "Remember me"

  // Phương thức đăng nhập
  Future<void> loginUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Nếu đăng nhập thành công, hiển thị dialog và chuyển sang màn hình chat
      _showSuccessDialog();
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      }

      // Hiển thị dialog lỗi
      _showErrorDialog(message);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Không cho phép đóng dialog khi nhấn bên ngoài
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock, size: 70, color: Color(0xFF4E0189)), // Biểu tượng thành công
                SizedBox(height: 20),
                Text(
                  'Login Successful!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4E0189),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Please wait...\nYou will be directed to the homepage.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                CircularProgressIndicator(), // Vòng xoay để thể hiện đang tải
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );

    // Đóng dialog sau vài giây và chuyển đến màn hình chat
    // Chuyển sang màn hình LoginScreen sau 2 giây
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/HomeChat');
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tài khoản và mật khẩu sai, vui lòng đăng nhập lại'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
                'Welcome Back 👋',
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
                'Please enter your email & password to login to your account',
                style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
              ),
            ),
            SizedBox(height: 30),

            // Email Field
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

            // Password Field
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

            // Remember me checkbox
            Row(
              children: [
                Checkbox(
                  value: rememberMe,
                  onChanged: (bool? value) {
                    setState(() {
                      rememberMe = value ?? false;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    'Remember me',
                    style: TextStyle(fontSize: 12, fontFamily: 'Poppins'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Login Button
            ElevatedButton(
              onPressed: () {
                // Gọi phương thức đăng nhập
                loginUser();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4E0189),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 180, vertical: 15),
              ),
              child: Text('Login', style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'Poppins')),
            ),

            Spacer(),

            // Đăng ký tài khoản
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Not have an Account? ', style: TextStyle(fontFamily: 'Poppins')),
                GestureDetector(
                  onTap: () {
                    // Chuyển sang trang đăng ký
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text(
                    'Sign up',
                    style: TextStyle(color: Color(0xFF4E0189), fontFamily: 'Poppins'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget xây dựng ô nhập liệu (Email & Password)
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

// Màn hình chat giả định
class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        backgroundColor: Color(0xFF4E0189),
      ),
      body: Center(
        child: Text('Welcome to the chat screen!'),
      ),
    );
  }
}
