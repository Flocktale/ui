import 'package:flocktale/Models/built_post.dart';

class Comment {
  SummaryUser user;
  String body;
  int timestamp;

  @override
  String toString() {
    return "${user.username}:::$body::::$timestamp";
  }
}
