import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'bottom_navigator_screen.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _currentUser = FirebaseAuth.instance.currentUser!;
  final _userCollection = FirebaseFirestore.instance.collection("users");
  final _firstNameController = TextEditingController(text: 'Nawapat');
  final _lastNameController = TextEditingController(text: 'Phongkhiao');
  final _phoneNumberController = TextEditingController(text: '081-123-4567');
  final _addressController = TextEditingController(
      text: 'ที่อยู่ หอพักแม่พลอย 315 ต.แม่กา อ.เมืองพะเยา จ.พะเยา 56000');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffF5F0F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Image.asset(
            'assets/images/icon-hew-hew.png',
            fit: BoxFit.cover,
            height: 60,
          ),
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'แก้ไขข้อมูลของฉัน',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomNavigatorScreen(),
                ),
              );
            },
            icon: const Icon(Icons.cancel_outlined),
            color: Colors.black,
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(75.0),
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16,),
                  TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1,
                          color: Color(0xFF828282),
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
                      labelText: "ชื่อ",
                      labelStyle: const TextStyle(
                        color: Color(0xFF828282),
                        fontSize: 14,
                        fontFamily: 'Mitr',
                        height: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1,
                          color: Color(0xFF828282),
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
                      labelText: "นามสกุล",
                      labelStyle: const TextStyle(
                        color: Color(0xFF828282),
                        fontSize: 14,
                        fontFamily: 'Mitr',
                        height: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1,
                          color: Color(0xFF828282),
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
                      labelText: "เบอร์โทรศัพท์",
                      labelStyle: const TextStyle(
                        color: Color(0xFF828282),
                        fontSize: 14,
                        fontFamily: 'Mitr',
                        height: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _addressController,
                    maxLines: null,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1,
                          color: Color(0xFF828282),
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
                      labelText: "ที่อยู่",
                      labelStyle: const TextStyle(
                        color: Color(0xFF828282),
                        fontSize: 14,
                        fontFamily: 'Mitr',
                        height: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffF9AF23),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),),
                      fixedSize: const Size(100, 50),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Miter',
                      ),
                    ),
                    onPressed: () async{
                      try {
                        await _userCollection.doc(_currentUser.uid).update({
                          'name': _firstNameController.text,
                          'last_name': _lastNameController.text,
                          'phoneNumber': _phoneNumberController.text,
                          'address': _addressController.text,
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('อัปเดตข้อมูลเรียบร้อยแล้ว')),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BottomNavigatorScreen(),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('เกิดข้อผิดพลาดในการอัปเดตข้อมูล: $e')),
                        );
                      }
                    },
                    child: const Text('บันทึก'),
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
