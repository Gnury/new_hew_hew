import 'package:flutter/material.dart';
import 'package:new_hew_hew/components/notification_card.dart';
import 'package:new_hew_hew/pages/bottom_navigator_screen.dart';

import '../components/post_user_info_card.dart';
import '../models/post_details.dart';

class NotificationPage extends StatefulWidget {
  final List<PostDetails>? notificationPost;
  const NotificationPage({super.key, required this.notificationPost});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavigatorScreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          color: Colors.black,
        ),
        title: const Row(
          children: [
            Spacer(),
            Text(
              'การแจ้งเตือน',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            SizedBox(
              width: 45,
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            PostUserInfoCard(),
            Expanded(
              child: NotificationCard(
                postDetails: widget.notificationPost,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
