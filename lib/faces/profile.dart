import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:petproject/auth/data/profile-provider.dart';
import 'package:provider/provider.dart';
import 'package:petproject/auth/presentation/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  String? selectedGender = 'Male';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          final data = doc.data()!;
          Provider.of<Profile>(context, listen: false).updateFromFirebase(data);

          setState(() {
            nameController.text = data['name'] ?? '';
            emailController.text = data['email'] ?? '';
            mobileController.text = data['mobile'] ?? '';
            dobController.text = data['dob'] ?? '';
            selectedGender = data['gender'] ?? 'Male';
          });
        }
      }
    } catch (e) {
      print('Error fetching profile data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: ${e.toString()}')),
      );
    }
  }

  Future<void> saveProfileData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user is currently logged in.');
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'mobile': mobileController.text.trim(),
        'dob': dobController.text.trim(),
        'gender': selectedGender,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      print('Error saving profile data: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<Profile>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const logInPage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          AssetImage('assets/avatar_placeholder.png'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      profile.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      profile.email,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              _buildInputField(
                label: 'User Name',
                icon: Icons.person,
                hint: 'Enter User Name',
                controller: nameController,
              ),
              const SizedBox(height: 20),
              _buildInputField(
                label: 'Email',
                icon: Icons.email,
                hint: 'Enter Email',
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email cannot be empty';
                  } else if (!value.contains('@')) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildInputField(
                label: 'Mobile Number',
                icon: Icons.phone,
                hint: 'Enter your 10-digit mobile number',
                controller: mobileController,
              ),
              const SizedBox(height: 20),
              _buildInputField(
                label: 'Date of Birth',
                icon: Icons.calendar_today,
                hint: 'DD / MM / YYYY',
                controller: dobController,
              ),
              const SizedBox(height: 20),
              _buildGenderDropdown(),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      profile.updateProfile(
                        name: nameController.text,
                        email: emailController.text,
                        mobile: mobileController.text,
                        dob: dobController.text,
                        gender: selectedGender!,
                      );
                      saveProfileData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Profile updated successfully!'),
                          backgroundColor: Colors.deepPurpleAccent,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                  ),
                  child: const Text(
                    'SAVE',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.deepPurpleAccent),
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedGender,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          items: const [
            DropdownMenuItem(value: 'Male', child: Text('Male')),
            DropdownMenuItem(value: 'Female', child: Text('Female')),
          ],
          onChanged: (value) {
            setState(() {
              selectedGender = value!;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a gender';
            }
            return null;
          },
        ),
      ],
    );
  }
}
