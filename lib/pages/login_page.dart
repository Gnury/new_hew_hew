import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:new_hew_hew/pages/bottom_navigator_screen.dart';
import 'package:new_hew_hew/pages/register_page.dart';

import 'admin_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> saveUserFcmToken(String? userEmail) async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await FirebaseFirestore.instance.collection('users').doc(userEmail).update({
        'fcm_token': token,
      });
    }
  }

  Future<void> updateUserLocationOnLogin(String? userEmail) async {
    try {
      if (userEmail != null) {
        LocationSettings locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.high,
        );

        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          permission = await Geolocator.requestPermission();
        }

        if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
          Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);

          await FirebaseFirestore.instance.collection('users').doc(userEmail).update({
            'latitude': position.latitude,
            'longitude': position.longitude,
            'lastLogin': FieldValue.serverTimestamp(),
          });
          print("Updated location to: ${position.latitude}, ${position.longitude}");
        } else {
          print("Location permission not granted");
        }
      }
    } catch (error) {
      throw "updateUserLocationOnLogin : $error";
    }
  }

  // String emailToDocId(String email) {
  //   return email.replaceAll('.', '_');
  // }

  void _signIn() async {
    final email = _emailController.text.trim().toLowerCase();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: _passwordController.text.trim(),
      );

      // final adminDocId = emailToDocId(email);
      final adminDoc = await FirebaseFirestore.instance.collection('admins').doc(email).get();
      if (!mounted) return;

      if (adminDoc.exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminPage()),
        );
      } else {
        await saveUserFcmToken(email);
        await updateUserLocationOnLogin(email);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavigatorScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message,),
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffF5F0F0),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 70,),
                  Image.asset(
                    'assets/images/icon-hew-hew.png',
                    fit: BoxFit.cover,
                    height: 150,
                  ),
                  const SizedBox(height: 55),

                  //email textfield
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xff7d7d7d),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        isDense: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xffF9AF23),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: "Email",
                        labelStyle: const TextStyle(
                          color: Color(0xff7d7d7d),
                          fontSize: 14,
                          fontFamily: 'Mitr',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                        hintText: "Email",
                        hintStyle: const TextStyle(
                          color: Color(0xFFC7C7CC),
                          fontSize: 14,
                          fontFamily: 'Mitr',
                          fontWeight: FontWeight.w300,
                          height: 0,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  //password text field
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xff7d7d7d),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        isDense: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 1,
                            color: Color(0xffF9AF23),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: "Password",
                        labelStyle: const TextStyle(
                          color: Color(0xff7d7d7d),
                          fontSize: 14,
                          fontFamily: 'Mitr',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                        hintText: "Password",
                        hintStyle: const TextStyle(
                          color: Color(0xFFC7C7CC),
                          fontSize: 14,
                          fontFamily: 'Mitr',
                          fontWeight: FontWeight.w300,
                          height: 0,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return SizedBox(); //ForgotPasswordPag();
                                },
                              ),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 14,
                              fontFamily: 'Mitr',
                              fontWeight: FontWeight.bold,
                              height: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  //sign in button
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: GestureDetector(
                      onTap: _signIn,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xffF9AF23),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'Mitr',
                              fontWeight: FontWeight.bold,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Not a member?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Mitr',
                          fontWeight: FontWeight.bold,
                          height: 0,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()),
                          );
                        }, //widget.showRegisterPage,
                        child: const Text(
                          'Register now',
                          style: TextStyle(
                            color: Color(0xffF9AF23),
                            fontSize: 14,
                            fontFamily: 'Mitr',
                            fontWeight: FontWeight.bold,
                            height: 0,
                          ),
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
