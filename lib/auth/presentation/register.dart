import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:petproject/auth/presentation/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  List<String> genders = ['Male', 'Female', 'Another'];
  String selectedGender = 'Male';

  final TextEditingController email = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController number = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  Future<void> createUserWithEmailandPassword() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim());
      print('User UID: ${userCredential.user?.uid}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );

      // Navigate to Login Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const logInPage()),
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
      case 'email-already-in-use':
        return 'This email is already in use. Try another one.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'weak-password':
        return 'The password is too weak.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // Image.asset(
                  //   'assets/skippy.gif',
                  //   height: 150,
                  // ),
                  const SizedBox(height: 20),
                  const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please register to login.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: name,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outline),
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_outlined),
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                          .hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: number,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone_outlined),
                      labelText: 'Mobile Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile number';
                      } else if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                        return 'Mobile number must be exactly 11 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    items: genders.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGender = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.wc),
                      labelText: 'Gender',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: password,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: createUserWithEmailandPassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const logInPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ],
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
