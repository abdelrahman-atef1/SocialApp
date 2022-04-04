import 'package:intl/intl.dart';
import 'package:social_app/models/comments_model/post_model.dart';
import 'package:social_app/shared/components/constants.dart' as constants;

class PostModel {
  String name = '';
  String uId = '';
  String profileImage = '';
  String? postImage = '';
  String postText = '';
  String dateTime = '';
  String postId = '';
  List<String>? likes = [];
  bool isLiked = false;
  int likesCount = 0;
  List<CommentsModel>? comments = [];

  PostModel(
      {this.name = '',
      this.uId = '',
      this.profileImage = constants.defaultImage,
      this.postImage = '',
      this.postText = '',
      this.dateTime = '',
      this.postId = '',
      this.likes,
      this.isLiked = false,
      this.likesCount = 0,
      this.comments});
  PostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'].toString();
    uId = json['uId'].toString();
    profileImage = json['profileImage'] ?? constants.defaultImage;
    postImage = json['postImage'];
    postText = json['postText'];
    var dateTimeParse = DateTime.parse(json['dateTime']);
    dateTime =
        DateFormat.yMMMd().addPattern("'a't h:m a").format(dateTimeParse);
  }

  Map<String, dynamic> toMap() {
    return {
      if (name != '') 'name': name,
      if (uId != '') 'uId': uId,
      if (profileImage != '') 'profileImage': profileImage,
      if (postImage != '') 'postImage': postImage ?? '',
      if (postText != '') 'postText': postText,
      if (dateTime != '') 'dateTime': dateTime,
    };
  }
}
