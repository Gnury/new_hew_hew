
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  // final SwiperController swiperController;

  const PostCard({
    super.key,
    // required this.swiperController,
  });
  //show data


  @override
  Widget build(BuildContext context) {
    return Padding(
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
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
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
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
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
                            'วันนี้ 10.30น.',
                            textAlign: TextAlign.start,
                            style: TextStyle(
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
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 6),
                      child: Text(
                        'postTitle',
                        style: TextStyle(
                          fontFamily: 'Mitr',
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                child: Row(),
              ),
              // Padding(
              //   padding: const EdgeInsetsDirectional.fromSTEB(
              //     0,
              //     0,
              //     0,
              //     12,
              //   ),
              //   child: SizedBox(
              //     height: MediaQuery.of(context).size.width - 64,
              //     width: 320,
              //     child: Stack(
              //       children: [
              //         Padding(
              //           padding: const EdgeInsetsDirectional.fromSTEB(
              //             0,
              //             0,
              //             0,
              //             12,
              //           ),
              //           //todo images
              //           // child: Swiper(
              //           //   controller: swiperController,
              //           //   itemCount: postImages.length,
              //           //   scrollDirection: Axis.horizontal,
              //           //   itemBuilder: (context, index) {
              //           //     final images = postImages[index];
              //           //     log("name: $postTitle ($images)");
              //           //     return Image.network(
              //           //       images,
              //           //       fit: BoxFit.cover,
              //           //     );
              //           //   },
              //           //   indicatorLayout: PageIndicatorLayout.COLOR,
              //           //   pagination: const SwiperPagination(),
              //           //   onIndexChanged: (index) {
              //           //     postImages[index];
              //           //   },
              //           // ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
