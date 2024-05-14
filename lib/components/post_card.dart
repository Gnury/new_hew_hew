import 'dart:developer';
import 'package:intl/intl.dart';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

import '../models/post_details.dart';

class PostCard extends StatelessWidget {
  final List<PostDetails>? postDetails;
  final SwiperController swiperController;

  const PostCard({
    super.key,
    required this.postDetails,
    required this.swiperController,
  });
  //show data

  @override
  Widget build(BuildContext context) {
    if (postDetails == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: postDetails?.length ?? 0,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        final postDetail = postDetails![index];
        final postTitle = postDetail.postTitle;
        final buyPlace = postDetail.buyPlace;
        final sendPlace = postDetail.sendPlace;
        final startDate = postDetail.startDate;
        final user = postDetail.user;
        final dueDate = postDetail.dueDate;
        final coins = postDetail.coins;
        final List<String> imageUrlList = postDetail.imageUrlList;
        int now = DateTime.now().millisecondsSinceEpoch;
        final bool isDueDateTime = dueDate <= now;

        return Opacity(
          opacity: (isDueDateTime) ? 0.4 : 0.1,
          child: Padding(
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
                padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 12),
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
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              12, 0, 0, 0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'ลี ยัง จุน',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontFamily: 'Mitr',
                                              color: Color(0xFF172026),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            'วันนี้ $startDate น.',
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
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 0, 6),
                                      child: Text(
                                        postTitle,
                                        style: const TextStyle(
                                          fontFamily: 'Mitr',
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    2, 0, 6, 0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              12, 6, 12, 6),
                                      child: Text(
                                        'สถานที่ซื้อของ $buyPlace',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontFamily: 'Mitr',
                                          color: Color(0xFF6229EE),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          12, 6, 12, 6),
                                      child: Text(
                                        'สถานที่นัดรับ $sendPlace',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontFamily: 'Mitr',
                                          color: Color(0xFF6229EE),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          12, 6, 12, 6),
                                      child: Text(
                                        'ราคา $coins เหรียญ',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontFamily: 'Mitr',
                                          color: Color(0xFF6229EE),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    2, 0, 6, 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(24),
                                      bottomRight: Radius.circular(24),
                                      topLeft: Radius.circular(24),
                                      topRight: Radius.circular(24),
                                    ),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: const Color(0xFF6229EE),
                                    ),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            12, 6, 12, 6),
                                    child: Text(
                                      'เปิดรับถึง ${DateFormat("h:m dd EEEE MMMM").format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            dueDate),
                                      )} น.',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: 'Mitr',
                                        color: Color(0xFF6229EE),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, 12),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width - 64,
                                  width: 320,
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 12),
                                        child: Swiper(
                                          controller: swiperController,
                                          itemCount: imageUrlList.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            final images = imageUrlList[index];
                                            log("name: $postTitle ($images)");
                                            return Image.network(
                                              images,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                          indicatorLayout:
                                              PageIndicatorLayout.COLOR,
                                          pagination: const SwiperPagination(),
                                          onIndexChanged: (index) {
                                            imageUrlList[index];
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
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
          ),
        );
      },
    );
  }
}
