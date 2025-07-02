import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentUser {
  final String? name;
  final String? lastName;
  final String? imageUrl;
  final int? coins;
  final String? address;
  final int? phoneNumber;
  final String email;
  final String? fcmToken;
  final double? latitude;
  final double? longitude;

  CurrentUser({
    this.coins,
    this.name,
    this.lastName,
    this.imageUrl,
    this.address,
    this.phoneNumber,
    this.fcmToken,
    this.latitude,
    this.longitude,
    required this.email,
  });

  factory CurrentUser.fromJson(DocumentSnapshot<Map<String, dynamic>> json) {
    final data = json.data()!;
    return CurrentUser(
      name: data["name"],
      lastName: data["last_name"],
      coins: data["coins"],
      imageUrl: data["image_url"],
      address: data["address"],
      phoneNumber: data["phone_number"],
      email: data["email"],
      fcmToken: data["fcm_token"],
      latitude: _toDouble(data["latitude"]),
      longitude: _toDouble(data["longitude"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "last_name": lastName,
    "coins": coins,
    "image_url": imageUrl,
    "address": address,
    "phone_number": phoneNumber,
    "email": email,
    "fcm_token": fcmToken,
    "latitude": latitude,
    "longitude": longitude,
  };

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return null;
  }
}

