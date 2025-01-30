import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:petproject/cubit/meditation_cubit.dart';
import 'package:petproject/faces/mainpage.dart';
import 'package:petproject/faces/profile.dart';
import 'package:petproject/firebase_options.dart';
import 'package:petproject/model/meditation_model.dart';
import 'package:petproject/provider.dart';
import 'package:petproject/welcome.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MeditationModelAdapter());

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Profile()),
      ChangeNotifierProvider(create: (_) => MeditationProvider()),
      BlocProvider(
          create: (context) => MeditationCubit()..loadCompletedSessions()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meditation',
      debugShowCheckedModeBanner: false,
      home: ResponsiveWrapper(),
    );
  }
}

class ResponsiveWrapper extends StatelessWidget {
  const ResponsiveWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return AuthenticationWrapper(desktop: true);
        } else {
          return AuthenticationWrapper(desktop: false);
        }
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  final bool desktop;
  const AuthenticationWrapper({super.key, required this.desktop});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return desktop ? DesktopMainPage() : BottomNavWithCards();
        } else {
          return const FirstPage();
        }
      },
    );
  }
}

class DesktopMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meditation - Desktop")),
      body: Row(
        children: [
          Expanded(flex: 2, child: NavigationRailSection()),
          Expanded(flex: 8, child: BottomNavWithCards()),
        ],
      ),
    );
  }
}

class NavigationRailSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: 0,
      onDestinationSelected: (int index) {},
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home),
          label: Text("Home"),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person),
          label: Text("Profile"),
        ),
      ],
    );
  }
}
