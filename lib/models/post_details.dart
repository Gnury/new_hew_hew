import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_hew_hew/models/user.dart';

class PostDetails {
  final String postTitle;
  final String buyPlace;
  final String sendPlace;
  final User? user;
  final Timestamp dueDate;
  final int coins;
  final List<String> imageUrlList;
  final Timestamp timeStamp;
  final bool getPost;

  const PostDetails({
    required this.postTitle,
    required this.dueDate,
    required this.user,
    required this.buyPlace,
    required this.sendPlace,
    required this.coins,
    required this.imageUrlList,
    required this.timeStamp,
    required this.getPost,
  });

  factory PostDetails.fromJson(Map<String, dynamic> json) => PostDetails(
    postTitle: json["post_title"],
    user: json["user"],
    dueDate: json["due_date"],
    buyPlace: json["buy_place"],
    sendPlace: json["send_place"],
    coins: json["coins"],
    imageUrlList: List<String>.from(json["image_url_list"].map((x) => x)),
    timeStamp: json["Timestamp"],
    getPost: json["get_post"],
  );

  Map<String, dynamic> toJson() => {
    "post_title": postTitle,
    "user": user,
    "due_date": dueDate,
    "buy_place": buyPlace,
    "send_place": sendPlace,
    "coins": coins,
    "image_url_list": List<dynamic>.from(imageUrlList.map((x) => x)),
    "Timestamp": timeStamp,
    "get_post": getPost,
  };
}
