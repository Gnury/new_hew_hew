import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_hew_hew/models/post_details.dart';

class CurrentUser {
  final String? name;
  final String? lastName;
  final String? imageUrl;
  final int? coins;
  final String? address;
  final int? phoneNumber;
  final String? email;

  CurrentUser({
    this.coins,
    this.name,
    this.lastName,
    this.imageUrl,
    this.address,
    this.phoneNumber,
    this.email
  });

  factory CurrentUser.fromJson(DocumentSnapshot<Map<String, dynamic>> json) => CurrentUser(
    name: json["name"],
    lastName: json["last_name"],
    coins: json["coins"],
    imageUrl: json["image_url"],
    address: json["address"],
    phoneNumber: json["phone_number"],
    email: json["email"]
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "last_name": lastName,
    "coins": coins,
    "image_url": imageUrl,
    "address": address,
    "phone_number": phoneNumber,
    "email": email,
  };
}
