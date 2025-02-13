import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petproject/auth/presentation/register.dart';
import 'package:petproject/faces/mainpage.dart';

class logInPage extends StatefulWidget {
  const logInPage({super.key});

  @override
  State<logInPage> createState() => _logInPageState();
}

class _logInPageState extends State<logInPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> loginUserWithEmailAndPassword() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavWithCards()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_mapFirebaseError(e.code))),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _mapFirebaseError(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found for this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'The email address is not valid.';
      default:
        return 'An unexpected error occurred.';
    }
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Breathe In'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(20),
                  //   child: Image.asset(
                  //     'assets/skippy.gif',
                  //     height: 150,
                  //     width: 150,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome Back',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Log In',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(
                    label: 'Email',
                    icon: Icons.email_outlined,
                    controller: email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!value.contains('@')) {
                        return 'Email must contain "@"';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Password',
                    icon: Icons.lock_outline,
                    controller: password,
                    isPassword: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              loginUserWithEmailAndPassword();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Log In',
                            style: TextStyle(fontSize: 20),
                          ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
