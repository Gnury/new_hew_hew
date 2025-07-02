import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_hew_hew/pages/bottom_navigator_screen.dart';

import 'admin_page.dart';
import 'login_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  Future<bool> isAdmin(String email) async {
    final doc = await FirebaseFirestore.instance
        .collection('admins')
        .doc(email)
        .get();

    return doc.exists;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;
          final email = user.email ?? '';

          return FutureBuilder<bool>(
            future: isAdmin(email),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.data == true) {
                return const AdminPage();
              } else {
                return const BottomNavigatorScreen();
              }
            },
          );
        } else {
          return const LoginPage();
        }
      },
    ));
  }
}
