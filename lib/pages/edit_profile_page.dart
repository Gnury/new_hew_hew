import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_hew_hew/models/user.dart';


class EditProfilePage extends StatefulWidget {
  final CurrentUser? user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ImagePicker _picker = ImagePicker();
  String? _image;

  final _userCollection = FirebaseFirestore.instance.collection("users");
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user?.name);
    _lastNameController = TextEditingController(text: widget.user?.lastName);
    _phoneNumberController =
        TextEditingController(text: widget.user?.phoneNumber.toString());
    _addressController = TextEditingController(text: widget.user?.address);
    _image = widget.user?.imageUrl;
  }

  @override
  void didUpdateWidget(covariant EditProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _firstNameController = TextEditingController(text: widget.user?.name);
    _lastNameController = TextEditingController(text: widget.user?.lastName);
    _phoneNumberController =
        TextEditingController(text: widget.user?.phoneNumber.toString());
    _addressController = TextEditingController(text: widget.user?.address);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<String?> uploadToDatabase(XFile imageURL) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('profile_images');
      UploadTask uploadTask = storageRef.putFile(File(imageURL.path));
      await uploadTask.whenComplete(() {});

      final downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (error) {
      print("uploadToDatabase : $error");
      return null;
    }

    // await FirebaseFirestore.instance.collection("posts").doc().set({
  }

  Future pickImage() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      String? profile = await uploadToDatabase(image);
      if (profile == null) return;
      setState(() {
        _image = profile;
        Navigator.pop(context);
      });
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickCameraImage() async {
    try {
      final picture = await _picker.pickImage(source: ImageSource.camera);
      if (picture == null) return;
      String? profile = await uploadToDatabase(picture);
      if (profile == null) return;
      setState(() {
        _image = profile;
        Navigator.pop(context);
      });
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future showSelectImageOptions() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
          height: 200,
          padding: const EdgeInsets.all(24),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "เพิ่มรูปภาพ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xffF9AF23),
                  fontSize: 20,
                  fontFamily: 'Mitr',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Form(
                // key: _formImage,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        pickImage();
                      },
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              color: Color(0xffF9AF23),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_library,
                              color: Color(0xffF9AF23),
                            ),
                            Text(
                              'อัปโหลด',
                              style: TextStyle(
                                color: Color(0xffF9AF23),
                                fontSize: 16,
                                fontFamily: 'Mitr',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    InkWell(
                      onTap: () {
                        pickCameraImage();
                      },
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              color: Color(0xffF9AF23),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: Color(0xffF9AF23),
                            ),
                            Text(
                              'ถ่ายภาพ',
                              style: TextStyle(
                                color: Color(0xffF9AF23),
                                fontSize: 16,
                                fontFamily: 'Mitr',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
              Navigator.pop(context);
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
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      showSelectImageOptions();
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(_image ??
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbya74AEa-lvSprh8v5HE5PF2I3MSXBlWj5Q&s"),
                            fit: BoxFit.cover),
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(75.0),
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
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
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      fixedSize: const Size(100, 50),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Miter',
                      ),
                    ),
                    onPressed: () async {
                      try {
                        await _userCollection.doc(widget.user?.email).update({
                          'name': _firstNameController.text,
                          'last_name': _lastNameController.text,
                          'phoneNumber': _phoneNumberController.text,
                          'address': _addressController.text,
                          'image_url' : _image,

                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('อัปเดตข้อมูลเรียบร้อยแล้ว')),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('เกิดข้อผิดพลาดในการอัปเดตข้อมูล: $e')),
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
