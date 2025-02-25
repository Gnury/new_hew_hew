
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../models/post_details.dart';

class NotificationCard extends StatelessWidget {
  final List<PostDetails>? postDetails;


  const NotificationCard({
    super.key,
    required this.postDetails,
  });
  //show data

  bool useCoinToCheckPost(int? price, int? coins) {
    if (price == null && coins == null) return false;
    var percent = price! * 0.5;
    if (coins! >= percent) {
      return true;
    }
    return false;
  }



  @override
  Widget build(BuildContext context) {
    if (postDetails == null) return Container();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: postDetails?.length ?? 0,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        final postDetail = postDetails![index];
        final postTitle = postDetail.postTitle;
        final buyPlace = postDetail.buyPlace;
        final sendPlace = postDetail.sendPlace;
        final user = postDetail.user;
        final dueDate = postDetail.dueDate;
        final coins = postDetail.coins;
        final List<String> imageUrlList = postDetail.imageUrlList;
        final bool getPost = postDetail.getPost;
        final timestamp = postDetail.timeStamp;
        int now = DateTime.now().millisecondsSinceEpoch;
        if (getPost) {
          return
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 12),
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
                                      Container(
                                        width: 44,
                                        height: 44,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.network(
                                          'https://images.unsplash.com/photo-1611604548018-d56bbd85d681?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwzfHxsZWdvfGVufDB8fHx8MTcwNzMzMjIyMnww&ixlib=rb-4.0.3&q=80&w=1080',
                                          // user.imageUrl.toString(),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            12, 4, 0, 12),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${user?.name} ${user?.lastName}",
                                              // user.fullName.toString(),
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(
                                                fontFamily: 'Mitr',
                                                color: Color(0xFF172026),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              DateFormat("EEEE dd MMMM hh:mm a").format(
                                                timestamp.toDate(),
                                              ),
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(
                                                fontFamily: 'Mitr',
                                                color: Color(0xFF36485C),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                              ),
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
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 6),
                                        child: Text(
                                          'รายละเอียดสินค้า:  $postTitle',
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            fontFamily: 'Mitr',
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 6),
                                        child: Text(
                                          'สถานที่ซื้อของ: $buyPlace',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontFamily: 'Mitr',
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 6),
                                        child: Text(
                                          'สถานที่นัดรับ: $sendPlace',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontFamily: 'Mitr',
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 6),
                                        child: Text(
                                          'เปิดรับถึง: ${DateFormat("EEEE dd MMMM hh:mm a").format(
                                            dueDate.toDate(),
                                          )}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontFamily: 'Mitr',
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 6),
                                        child: Text(
                                          'ราคา $coins เหรียญ',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontFamily: 'Mitr',
                                            color: Color(0xffF9AF23),
                                            fontWeight: FontWeight.w300,
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
                      ),
                    ],
                  ),
                ),
              ),
              // ),
            );
        }
        return   Container();
      },
    );
  }
}
