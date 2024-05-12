// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../models/user.dart';
//
// class Api{
//   Future<QuerySnapshot<Object?>> getFirestore ()async{
//     return await FirebaseFirestore.instance.collection('user').get();
//   }
//
//   Future<List<User>> getUser() async {
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('user').get();
//     return querySnapshot.docs.map((user) {
//       return User(
//         fullName: user["full_name"],
//         userId: user["user_id"],
//         coins: user["coins"],
//         imageUrl: user["image_url"],
//       );
//     }).toList();
//   }
//
// }