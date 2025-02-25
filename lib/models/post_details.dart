import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_hew_hew/models/user.dart';

class PostDetails {
  final String postTitle;
  final String buyPlace;
  final String sendPlace;
  final CurrentUser? user;
  final Timestamp dueDate;
  final int coins;
  final List<String> imageUrlList;
  final Timestamp timeStamp;
  final bool getPost;
  final String imageUrl;
  final String name;
  final String lastName;
  // final String uid;

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
    required this.imageUrl,
    required this.lastName,
    required this.name,
    // required this.uid,
  });

  factory PostDetails.fromJson(Map<String, dynamic> json/*,{required String uid}*/) => PostDetails(
    postTitle: json["post_title"],
    user: json["user"],
    dueDate: json["due_date"],
    buyPlace: json["buy_place"],
    sendPlace: json["send_place"],
    coins: json["coins"],
    imageUrlList: List<String>.from(json["image_url_list"].map((x) => x)),
    timeStamp: json["Timestamp"],
    getPost: json["get_post"],
    name: json["name"],
    lastName: json["last_name"],
    imageUrl: json["image_url"],
    // uid: uid,
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
    "name": name,
    "last_name": lastName,
    "image_url": imageUrl,
  };
}
