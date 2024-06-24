import 'package:flutter/material.dart';

import '../models/post_details.dart';

class NotificationCard extends StatelessWidget {
  final List<PostDetails>? postDetails;

  const NotificationCard({
    super.key,
    required this.postDetails,
  });

  @override
  Widget build(BuildContext context) {
    if (postDetails == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: postDetails?.length ?? 0,
      itemBuilder: (context, index) {
        final postDetail = postDetails![index];
        final postTitle = postDetail.postTitle;
        final buyPlace = postDetail.buyPlace;
        final sendPlace = postDetail.sendPlace;
        // final user = postDetail.user!;
        final dueDate = postDetail.dueDate;
        final coins = postDetail.coins;
        final List<String> imageUrlList = postDetail.imageUrlList;

        return Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
          child: Container(
            width: double.infinity,
            
          ),
        );
      },
    );
  }
}
