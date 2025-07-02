import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_hew_hew/components/my_posts.dart';
import 'package:new_hew_hew/firebase/firebase_service_api.dart';
import 'package:new_hew_hew/pages/edit_profile_page.dart';
import 'package:new_hew_hew/pages/login_page.dart';
import '../models/order_log.dart';
import '../models/post_details.dart';
import '../models/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  CurrentUser? currentUser;
  FirebaseService userService = FirebaseService();
  final CollectionReference<Map<String, dynamic>> _userCollection = FirebaseFirestore.instance.collection("users");
  List<PostDetails> posts = [];
  List<OrderLog> steps = [];


  final swiperController = SwiperController();

  @override
  void initState() {
    super.initState();
    _getUser();
  }


  Future<void> _getUser() async {
    var thisUser = await userService.getUser();
    setState(() {
      if (thisUser == null) return;
      currentUser = thisUser;
    });
    if (currentUser?.email == null) return;
    _getUserPosts(currentUser!.email);
  }

  Future<void> _getUserPosts(String email) async {
    final result = await userService.getUserPosts(email);
    setState(() {
      posts = result;
    });
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  Future<bool> deductCoins(int postCoin, int userCoins) async {
    if (userCoins - postCoin >= postCoin) {
      userCoins -= postCoin;
      await userService.updateCoin(
          email: currentUser?.email, coin: userCoins);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser != null) {
      print("Current User: ${currentUser?.name} ${currentUser?.lastName}");
    }
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
              'ข้อมูลของฉัน',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 42,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
            color: Colors.black,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(24, 24, 24, 24),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(6, 6, 6, 6),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(6, 0, 6, 12),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          12, 12, 12, 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 12),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 70,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.network(
                                        currentUser?.imageUrl.toString() == ''
                                            ? currentUser?.imageUrl.toString() ?? ''
                                            : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbya74AEa-lvSprh8v5HE5PF2I3MSXBlWj5Q&s",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditProfilePage(
                                                  user: currentUser,
                                                ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "แก้ไขข้อมูล",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      40, 2, 0, 12),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${currentUser?.name} ${currentUser?.lastName}",
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          fontFamily: 'Mitr',
                                          color: Color(0xFF172026),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.pin_drop_outlined,
                                            color: Color(0xffF9AF23),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            currentUser?.address ?? "กรุณาเพิ่มที่อยู่",
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                              fontFamily: 'Mitr',
                                              color: Color(0xFF36485C),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.phone,
                                            color: Color(0xffF9AF23),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            currentUser?.phoneNumber.toString() ??
                                                "กรุณาเพิ่มเบอร์โทรศัพท์",
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                              fontFamily: 'Mitr',
                                              color: Color(0xFF36485C),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                              ],
                            ),
                          ),
                          StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(currentUser?.email)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData || !snapshot.data!.exists) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              final userData = snapshot.data!.data() as Map<String, dynamic>;
                              final int coins = userData['coins'] ?? 0;

                              return Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsetsDirectional.all(20),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color(0xffF9AF23),
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Coins : "),
                                            Text("$coins      Coins"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
               showMyPost(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget showMyPost() {
    return SizedBox(
      height: 375,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "การฝากหิ้วของฉัน",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
      
            const SizedBox(height: 12),
      
            Expanded(
              child: MyPost(
                swiperController: swiperController,
                postDetails: posts,
                orderLogList: steps,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
