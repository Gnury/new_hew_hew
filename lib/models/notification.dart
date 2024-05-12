import 'package:new_hew_hew/models/post_details.dart';
import 'package:new_hew_hew/models/user.dart';

class Notification {
  final List<PostDetails>? postDetail;
  final User? user;
  final DateTime? notificationTime;

  Notification({this.user, this.postDetail, this.notificationTime});
}
