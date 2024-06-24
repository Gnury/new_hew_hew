import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_hew_hew/pages/auth_page.dart';
import 'package:new_hew_hew/pages/bottom_navigator_screen.dart';

import 'firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: AuthPage(),
        //BottomNavigatorScreen(),
      ),
    );

  }
}
