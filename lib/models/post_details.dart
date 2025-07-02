import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_hew_hew/models/user.dart';

class PostDetails {
  final String? postTitle;
  final String? buyPlace;
  final String? sendPlace;
  final CurrentUser? user;
  final Timestamp? dueDate;
  final int? coins;
  final List<String>? imageUrlList;
  final Timestamp? timeStamp;
  final bool? getPost;
  final String? imageUrl;
  final String? name;
  final String? lastName;
  final String? email;
  final String? id;
  final double? latitude;
  final double? longitude;
  final String? receiveUserEmail;

  const PostDetails({
    this.postTitle,
    this.dueDate,
    this.user,
    this.buyPlace,
    this.sendPlace,
    this.coins,
    this.imageUrlList,
    this.timeStamp,
    this.getPost,
    this.imageUrl,
    this.lastName,
    this.name,
    this.email,
    this.id,
    this.latitude,
    this.longitude,
    this.receiveUserEmail,
  });

  factory PostDetails.fromDocument(DocumentSnapshot doc) {
    final json = doc.data() as Map<String, dynamic>;
    return PostDetails(
      postTitle: json["post_title"],
      user: json["user"],
      dueDate: json["due_date"],
      buyPlace: json["buy_place"],
      sendPlace: json["send_place"],
      coins: json["coins"],
      imageUrlList: json["image_url_list"] != null
          ? List<String>.from(json["image_url_list"].map((x) => x))
          : null,
      timeStamp: json["Timestamp"],
      getPost: json["get_post"],
      name: json["name"],
      lastName: json["last_name"],
      imageUrl: json["image_url"],
      email: json["email"],
      id: doc.id,
      latitude: _toDouble(json["latitude"]),
      longitude: _toDouble(json["longitude"]),
      receiveUserEmail: json["receive_user_email"],
    );
  }


  Map<String, dynamic> toJson() => {
    "post_title": postTitle,
    "user": user,
    "due_date": dueDate,
    "buy_place": buyPlace,
    "send_place": sendPlace,
    "coins": coins,
    "image_url_list":
    imageUrlList != null ? List<dynamic>.from(imageUrlList!.map((x) => x)) : null,
    "Timestamp": timeStamp,
    "get_post": getPost,
    "name": name,
    "last_name": lastName,
    "image_url": imageUrl,
    "email": email,
    "id": id,
    "latitude": latitude,
    "longitude": longitude,
    "receive_user_email": receiveUserEmail,
  };

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return null;
  }
}

