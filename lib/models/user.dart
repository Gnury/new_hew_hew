import 'package:new_hew_hew/models/post_details.dart';

class User {
  final String? fullName;
  final int? userId;
  final String? imageUrl;
  final int? coins;
  final List<PostDetails>? postDetails;

  User({
    this.coins,
    this.fullName,
    this.userId,
    this.imageUrl,
    this.postDetails,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    fullName: json["full_name"],
    userId: json["user_id"],
    coins: json["coins"],
    imageUrl: json["image_url"],
    postDetails: List<PostDetails>.from(json["post_details"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "full_name": fullName,
    "user_id": userId,
    "coins": coins,
    "image_url": imageUrl,
    "post_details": List<dynamic>.from(postDetails!.map((x) => x)),
  };
}
