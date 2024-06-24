import 'package:new_hew_hew/models/post_details.dart';

class User {
  final String? name;
  final String? lastName;
  final String? imageUrl;
  final int? coins;
  final List<PostDetails>? postDetails;
  final String? address;
  final int? phoneNumber;

  User({
    this.coins,
    this.name,
    this.lastName,
    this.imageUrl,
    this.postDetails,
    this.address,
    this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    lastName: json["last_name"],
    coins: json["coins"],
    imageUrl: json["image_url"],
    postDetails: List<PostDetails>.from(json["post_details"].map((x) => x)),
    address: json["address"],
    phoneNumber: json["phone_number"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "last_name": lastName,
    "coins": coins,
    "image_url": imageUrl,
    "post_details": List<dynamic>.from(postDetails!.map((x) => x)),
    "address": address,
    "phone_number": phoneNumber,
  };
}
