import 'package:new_hew_hew/models/user.dart';

class PostDetails {
  final String postTitle;
  final String postId;
  final String buyPlace;
  final String sendPlace;
  final User? user;
  final int startDate;
  final int dueDate;
  final int coins;
  final List<String> imageUrlList;

  const PostDetails({
    required this.postTitle,
    required this.postId,
    required this.startDate,
    required this.dueDate,
    required this.user,
    required this.buyPlace,
    required this.sendPlace,
    required this.coins,
    required this.imageUrlList,
  });

  factory PostDetails.fromJson(Map<String, dynamic> json) => PostDetails(
    postTitle: json["post_title"],
    postId: json["post_detail"],
    user: json["user"],
    startDate: json["start_date"],
    dueDate: json["due_date"],
    buyPlace: json["buy_place"],
    sendPlace: json["send_place"],
    coins: json["coins"],
    imageUrlList: List<String>.from(json["image_url_list"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "post_title": postTitle,
    "post_detail": postId,
    "user": user,
    "start_date": startDate,
    "due_date": dueDate,
    "buy_place": buyPlace,
    "send_place": sendPlace,
    "coins": coins,
    "image_url_list": List<dynamic>.from(imageUrlList.map((x) => x)),
  };
}
