import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petproject/auth/data/profile-provider.dart';
import 'package:petproject/studypage/data/meditation_cubit.dart';
import 'package:petproject/faces/mainpage.dart';
import 'package:petproject/firebase_options.dart';

import 'package:petproject/provider.dart';
import 'package:petproject/welcome.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Profile()),
        ChangeNotifierProvider(create: (_) => MeditationProvider()),
        BlocProvider(
            create: (context) => MeditationCubit()..loadCompletedSessions()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meditation',
      debugShowCheckedModeBanner: false,
      home: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return BottomNavWithCards();
        } else {
          return const FirstPage();
        }
      },
    );
  }
}
