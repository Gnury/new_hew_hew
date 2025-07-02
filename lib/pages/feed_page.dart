import 'dart:async';
import 'dart:developer';

import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:new_hew_hew/components/post_card.dart';
import 'package:new_hew_hew/pages/create_post_page.dart';
import 'package:new_hew_hew/pages/notification_page.dart';

import '../firebase/firebase_service_api.dart';
import '../models/post_details.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final FirebaseService _firebaseService = FirebaseService();
  final swiperController = SwiperController();

  List<PostDetails>? posts;
  Map<String, List<DocumentSnapshot>> titleMap = {};
  Map<String, List<DocumentSnapshot>> buyPlaceMap = {};

  final searchController = TextEditingController();
  Timer? _debounce;
  List<PostDetails> _filterData = [];

  String searchQuery = "";

  void debouncedSearch(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        setState(
          () {
            searchQuery = value;
            _onSearchChange();
          },
        );
      },
    );
  }

  Future<void> _onSearchChange() async {
    if (posts == null) return;

    List<PostDetails> filteredList = posts!.where((post) {
      final title = post.postTitle?.toLowerCase();
      final buyPlace = post.buyPlace?.toLowerCase();
      final query = searchQuery.toLowerCase();

      return title!.contains(query) || buyPlace!.contains(query);
    }).toList();

    setState(() {
      _filterData = filteredList;
    });
  }

  @override
  void initState() {
    super.initState();
    _getPosts();
  }
  //filter category
  void fetchData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('posts').get();

    Map<String, List<DocumentSnapshot>> tempTitleMap = {};
    Map<String, List<DocumentSnapshot>> tempBuyPlaceMap = {};

    for (var doc in snapshot.docs) {
      String title = doc['postTitle'];
      String place = doc['buyPlace'];

      if (!tempTitleMap.containsKey(title)) {
        tempTitleMap[title] = [];
      }
      tempTitleMap[title]!.add(doc);

      if (!tempBuyPlaceMap.containsKey(place)) {
        tempBuyPlaceMap[place] = [];
      }
      tempBuyPlaceMap[place]!.add(doc);
    }

    setState(() {
      titleMap = tempTitleMap;
      buyPlaceMap = tempBuyPlaceMap;
    });
  }

  Future<void> _getPosts() async {
    try {
      geo.Position position = await geo.Geolocator.getCurrentPosition();

      final result = await _firebaseService.getPosts(
        userLat: position.latitude,
        userLon: position.longitude,
      );

      setState(() {
        posts = result;
        if (searchQuery.isNotEmpty) {
          _filterData = posts!
              .where((post) =>
          (post.postTitle?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false) ||
              (post.buyPlace?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false))
              .toList();
        }
      });
    } catch (e) {
      log('Error loading posts: $e');
    }
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24, 6, 24, 6),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 1,
                    color: Color(0xffF9AF23),
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
                labelText: "🔎 ค้นหาสินค้าที่สนใจรับหิ้ว",
                labelStyle: const TextStyle(
                  color: Color(0xFF36485C),
                  fontSize: 14,
                  fontFamily: 'Mitr',
                  fontWeight: FontWeight.w300,
                  height: 0,
                ),
              ),
              onChanged: (val) {
               debouncedSearch(val);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _createPostButton() {
    return FloatingActionButton(
      backgroundColor: const Color(0xfff9af23),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreatePostPage(),
          ),
        ).then((value) => _getPosts());
      },
      child: const Icon(Icons.add),
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
            Spacer(),
            Text(
              'โพสต์ฝากหิ้ว',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
          ],
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) =>
        //               NotificationPage(notificationPost: posts),
        //         ),
        //       );
        //     },
        //     icon: const Icon(Icons.notifications_active),
        //     color: Colors.black,
        //   ),
        // ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _searchBar(),
          const SizedBox(height: 12),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _getPosts, // ดึงข้อมูลใหม่
              child: Visibility(
                visible: searchQuery.isNotEmpty,
                replacement: posts == null
                    ? const Center(child: CircularProgressIndicator())
                    : PostCard(
                  swiperController: swiperController,
                  postDetails: posts,
                ),
                child: PostCard(
                  swiperController: swiperController,
                  postDetails: _filterData,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _createPostButton(),
    );
  }
}
// }
