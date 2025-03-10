import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/post_details.dart';
import '../models/user.dart';

class FirebaseService {
  final db = FirebaseFirestore.instance;

  Future<List<PostDetails>> getPosts() async {
    try {
      final query = await db.collection("posts").orderBy("Timestamp", descending: true).get();
      print("query: ${query.docs.length}");
      // final data = query.docs.map((e) => e.data()).toList();
      // log("data $data");
      final data = query.docs.map((doc) =>
        PostDetails.fromJson(doc.data())).toList();
      print("data $data");
      return data;

    } catch (error) {
      rethrow;
    }
  }

  Future<CurrentUser>? getUser() async{
    try {
      final data = await db.collection("users").doc("dd@gmail.com").get();
      return CurrentUser.fromJson(data);

    }catch (error) {
      rethrow;
    }
  }
}