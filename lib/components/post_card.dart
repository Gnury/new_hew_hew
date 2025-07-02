import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:new_hew_hew/const.dart';
import 'package:new_hew_hew/models/user.dart';

import '../firebase/firebase_service_api.dart';
import '../models/order_log.dart';
import '../models/post_details.dart';
import 'firebase_msg.dart';

class PostCard extends StatefulWidget {
  final List<PostDetails>? postDetails;
  final SwiperController swiperController;

  const PostCard({
    super.key,
    required this.postDetails,
    required this.swiperController,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final FirebaseService firebaseService = FirebaseService();
  final FirebaseService userService = FirebaseService();
  CurrentUser? currentUser;
  List<OrderLog>? orderLog;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> sendNotification(
      List<PostDetails> postDetail, String user) async {
    await FirebaseFirestore.instance.collection('notifications').doc().set({
      'postDetail': postDetail,
      'user': user,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<bool> deductCoins(int postCoin, int userCoins, String email) async {
    if (userCoins >= postCoin) {
      final newCoins = userCoins - (postCoin ~/ 2);
      await firebaseService.updateCoin(email: email, coin: newCoins);
      return true;
    }
    return false;
  }

  Future<int> getUserCoin(String email) async {
    final coinData =
        await FirebaseFirestore.instance.collection('users').doc(email).get();
    return coinData.data()?['coins'] ?? 0;
  }

  Future<void> _getUser() async {
    final thisUser = await userService.getUser();
    if (mounted) {
      setState(() {
        currentUser = thisUser;
      });
    }
  }

  Future<void> _setLog() async {
    final getLog = await FirebaseService().setLog();
    setState(() {
      orderLog = getLog;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.postDetails == null) return Container();

    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.postDetails?.length ?? 0,
      itemBuilder: (context, index) {
        final postDetail = widget.postDetails![index];
        final email = postDetail.email;
        final postTitle = postDetail.postTitle;
        final buyPlace = postDetail.buyPlace;
        final sendPlace = postDetail.sendPlace;
        final name = postDetail.name;
        final lastName = postDetail.lastName;
        final imageUrl = (postDetail.imageUrl == null ||
                postDetail.imageUrl!.isEmpty)
            ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbya74AEa-lvSprh8v5HE5PF2I3MSXBlWj5Q&s'
            : postDetail.imageUrl!;
        final dueDate = postDetail.dueDate;
        final coins = postDetail.coins;
        final imageUrlList = postDetail.imageUrlList;
        final getPost = postDetail.getPost ?? false;
        final timestamp = postDetail.timeStamp;
        final receiveUserEmail = postDetail.receiveUserEmail;

        if (getPost ||
            dueDate == null || receiveUserEmail != null && receiveUserEmail.isNotEmpty || dueDate.toDate().isBefore(DateTime.now())) {
          return Container();
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipOval(
                        child: Image.network(
                          imageUrl,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$name $lastName",
                            style: const TextStyle(
                              fontFamily: 'Mitr',
                              color: Color(0xFF172026),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (timestamp != null)
                            Text(
                              DateFormat("EEEE dd MMMM hh:mm a")
                                  .format(timestamp.toDate()),
                              style: const TextStyle(
                                fontFamily: 'Mitr',
                                color: Color(0xFF36485C),
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'รายละเอียดสินค้า: $postTitle',
                    style: _infoTextStyle(),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'สถานที่ซื้อของ: $buyPlace',
                    style: _infoTextStyle(),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'สถานที่นัดรับ: $sendPlace',
                    style: _infoTextStyle(),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'เปิดรับถึง: ${DateFormat("EEEE dd MMMM hh:mm a").format(dueDate.toDate())}',
                    style: _infoTextStyle(),
                  ),
                  const SizedBox(height: 5),
                  Text('ราคา $coins เหรียญ', style: _coinTextStyle()),
                  const SizedBox(height: 12),
                  if (imageUrlList != null &&
                      imageUrlList.isNotEmpty)
                    SizedBox(
                      height: MediaQuery.of(context).size.width - 64,
                      width: double.infinity,
                      child: Swiper(
                        controller: widget.swiperController,
                        itemCount: imageUrlList.length,
                        itemBuilder: (context, index) => Image.network(
                          imageUrlList[index],
                          fit: BoxFit.cover,
                        ),
                        pagination: const SwiperPagination(),
                      ),
                    ),
                  const SizedBox(height: 12),
                  if (currentUser?.email != email)
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffF9AF23),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fixedSize: const Size(120, 50),
                        ),
                        onPressed: () async {
                          try {
                            final userPostCoins = await getUserCoin(email!);
                            final canDeduct =
                                await deductCoins(coins!, userPostCoins, email);
                            if (canDeduct) {
                              await firebaseService.setOrder(
                                postId: postDetail.id!,
                                email: currentUser?.email,
                                statusLogOrder: StatusLogOrder.receive,
                              );
                              final fcmUser =
                                  await userService.getUser(thisEmail: email);
                              await SendNotification.sendNotification(
                                  fcmUser?.fcmToken,
                                  email,
                                  StatusLogOrder.receive);
                              await SendNotification.uploadNotification(
                                  email, StatusLogOrder.receive, postDetail.id!);
                              await sendNotification(
                                  [postDetail], currentUser?.email ?? '');

                              final int halfCoin = (postDetail.coins! / 2).round();
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(receiveUserEmail)
                                  .update({"coins": halfCoin});
                            }
                          } catch (e) {
                            log('Error on accepting order: $e');
                          }
                        },
                        child: const Text(
                          "รับหิ้ว",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Mitr',
                            color: Color(0xff5656FF),
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  TextStyle _infoTextStyle() => const TextStyle(
        fontFamily: 'Mitr',
        color: Colors.black,
        fontWeight: FontWeight.w300,
        fontSize: 15,
      );

  TextStyle _coinTextStyle() => const TextStyle(
        fontFamily: 'Mitr',
        color: Color(0xffF9AF23),
        fontWeight: FontWeight.w300,
        fontSize: 15,
      );
}
