import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:new_hew_hew/models/order_log.dart';
import '../models/post_details.dart';
import '../models/user.dart';

class FirebaseService {
  final db = FirebaseFirestore.instance;

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // km
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    double a =
        sin(dLat / 2) * sin(dLat / 2) +
            cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
                sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _toRadians(double degree) => degree * pi / 180;

  Future<List<PostDetails>> getPosts({required double userLat, required double userLon,}) async {
    const double maxDistanceInKm = 50;

    try {
      final query = await db
          .collection("posts")
          .orderBy("Timestamp", descending: true)
          .get();

      final rawData = query.docs.map((doc) => PostDetails.fromDocument(doc)).toList();

      // กรองโพสต์ในรัศมี 50 กม.
      List<PostDetails> filteredData = rawData.where((post) {
        if (post.latitude == null || post.longitude == null) return false;

        double distance = calculateDistance(
          userLat,
          userLon,
          post.latitude!,
          post.longitude!,
        );

        return distance <= maxDistanceInKm;
      }).toList();

      return filteredData;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<PostDetails>> getMyOrderList(String email) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> query = await db
          .collection("posts")
          .where("receive_user_email", isEqualTo: email)
          .get();
      return query.docs.map((doc) => PostDetails.fromDocument(doc)).toList();
    } catch (error) {
      rethrow;
    }
  }

  Future<List<PostDetails>> getUserPosts(String email) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> query = await db
          .collection("posts")
          .orderBy("Timestamp", descending: true)
          .get();
      final List<PostDetails> data =
          query.docs.map((doc) => PostDetails.fromDocument(doc)).toList();
      return data.where((PostDetails item) => item.email == email).toList();
    } catch (error) {
      rethrow;
    }
  }

  Future<List<OrderLog>> getLog(String id) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore
          .instance
          .collection('posts')
          .doc(id)
          .collection("log")
          .orderBy('status')
          .get();
      final List<OrderLog> data =
          query.docs.map((doc) => OrderLog.fromJson(doc.data())).toList();
      return data;
    } catch (error) {
      rethrow;
    }
  }

  Future<CurrentUser?> getUser({String? thisEmail}) async {
    try {
      String? email = thisEmail ?? FirebaseAuth.instance.currentUser?.email;
      if (email == null) {
        return null;
      }

      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await db.collection("users").doc(email).get();
      final user = CurrentUser.fromJson(docSnapshot);
      return user;
    } catch (error) {
      throw "getUser : $error";
    }
  }

  Future<List<OrderLog>> setLog() async {
    try {
      final log = await db.collection("posts").orderBy("id").get();
      final data =
          log.docs.map((doc) => OrderLog.fromJson(doc.data())).toList();
      return data;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> setOrder({
    required String postId,
    String? email,
    required int statusLogOrder,
  }) async {
    await FirebaseFirestore.instance.collection("posts").doc(postId).update(
      {
        'receive_user_email': email,
      },
    );
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("log")
        .doc()
        .set(
      {
        'status': statusLogOrder,
        'timestamp': DateTime.now(),
      },
    );
  }

  Future<void> updateCoin({String? email, required int coin}) async {
    try {
      await FirebaseFirestore.instance.collection("users").doc(email).update({
        "coins": coin,
      });
    } catch (error) {
      print(error);
    }
  }

  Future<bool> requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location service ปิดอยู่
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      // ต้องพาผู้ใช้ไปเปิดเองใน settings
      return false;
    }

    // ได้สิทธิ์แล้ว
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<List<OrderLog>> getNotification(String? thisEmail) async{
    try {
      final QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(thisEmail)
          .collection("notification")
          .orderBy('timestamp')
          .get();
      final List<OrderLog> data =
      query.docs.map((doc) => OrderLog.fromJson(doc.data())).toList();
      return data;
    } catch (error) {
      rethrow;
    }
  }
}
