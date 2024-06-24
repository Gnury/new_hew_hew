import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_hew_hew/pages/bottom_navigator_screen.dart';
import 'package:new_hew_hew/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> signUp(BuildContext context) async {
    if (_confirmPasswordController.text == _passwordController.text) {
      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        await addUserDetails(
          _nameController.text.trim(),
          _lastNameController.text.trim(),
          _emailController.text.trim(),
          _addressController.text.trim(),
          int.parse(_phoneNumberController.text.trim()),
        );

        // Navigate to the next screen or update the UI
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const BottomNavigatorScreen()),
        );
      } catch (e) {
        // Handle errors such as email already in use
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Error: ${e.toString()}"),
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Text("Passwords don't match!"),
          );
        },
      );
    }
  }

  Future<void> addUserDetails(
      String name,
      String lastName,
      String email,
      String address,
      int phoneNumber,
      ) async {
    await FirebaseFirestore.instance.collection('users').doc(email).set({
      'name': name,
      'last_name': lastName,
      'email': email,
      'address': address,
      'phone_number': phoneNumber,
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(email)
        .collection("info")
        .doc("profile")
        .set({
      'username': '$name $lastName',
      'address': address,
      'phoneNumber': phoneNumber,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Register',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: const [
          SizedBox(
            width: 45,
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/icon-hew-hew.png',
                  fit: BoxFit.cover,
                  height: 80,
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Color(0xFFF2F2F7),
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
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Color(0xFFF2F2F7),
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
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Color(0xFFF2F2F7),
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
                    labelText: "Confirm Password",
                    labelStyle: const TextStyle(
                      color: Color(0xff7d7d7d),
                      fontSize: 14,
                      fontFamily: 'Mitr',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                    hintText: "Confirm Password",
                    hintStyle: const TextStyle(
                      color: Color(0xFFC7C7CC),
                      fontSize: 14,
                      fontFamily: 'Mitr',
                      fontWeight: FontWeight.w300,
                      height: 0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Color(0xFFF2F2F7),
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
                    labelText: "First Name",
                    labelStyle: const TextStyle(
                      color: Color(0xff7d7d7d),
                      fontSize: 14,
                      fontFamily: 'Mitr',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                    hintText: "First Name",
                    hintStyle: const TextStyle(
                      color: Color(0xFFC7C7CC),
                      fontSize: 14,
                      fontFamily: 'Mitr',
                      fontWeight: FontWeight.w300,
                      height: 0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Color(0xFFF2F2F7),
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
                    labelText: "Last Name",
                    labelStyle: const TextStyle(
                      color: Color(0xff7d7d7d),
                      fontSize: 14,
                      fontFamily: 'Mitr',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                    hintText: "Last Name",
                    hintStyle: const TextStyle(
                      color: Color(0xFFC7C7CC),
                      fontSize: 14,
                      fontFamily: 'Mitr',
                      fontWeight: FontWeight.w300,
                      height: 0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Color(0xFFF2F2F7),
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
                    labelText: "Address",
                    labelStyle: const TextStyle(
                      color: Color(0xff7d7d7d),
                      fontSize: 14,
                      fontFamily: 'Mitr',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                    hintText: "Address",
                    hintStyle: const TextStyle(
                      color: Color(0xFFC7C7CC),
                      fontSize: 14,
                      fontFamily: 'Mitr',
                      fontWeight: FontWeight.w300,
                      height: 0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Color(0xFFF2F2F7),
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
                    labelText: "Phone Number",
                    labelStyle: const TextStyle(
                      color: Color(0xff7d7d7d),
                      fontSize: 14,
                      fontFamily: 'Mitr',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                    hintText: "Phone Number",
                    hintStyle: const TextStyle(
                      color: Color(0xFFC7C7CC),
                      fontSize: 14,
                      fontFamily: 'Mitr',
                      fontWeight: FontWeight.w300,
                      height: 0,
                    ),
                  ),
                ),

                const SizedBox(height: 25,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: () => signUp(context),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xffF9AF23),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
