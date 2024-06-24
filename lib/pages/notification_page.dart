import 'package:flutter/material.dart';
import 'package:new_hew_hew/components/notification_card.dart';
import 'package:new_hew_hew/pages/bottom_navigator_screen.dart';

import 'feed_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

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
            Expanded(child: NotificationCard(postDetails: [

            ],),)
          ],
        ),
      ),
    );
  }
}
