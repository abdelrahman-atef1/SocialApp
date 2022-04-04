import 'package:intl/intl.dart';
import 'package:social_app/shared/components/constants.dart' as constants;

class CommentsModel {
  String name = '';
  String profileImage = '';
  String commentText = '';
  String dateTime = '';

  CommentsModel({
    this.name = '',
    this.profileImage = constants.defaultImage,
    this.commentText = '',
    this.dateTime = '',
  });

  CommentsModel.fromJson(Map<String, dynamic> json) {
    name = json['name'].toString();
    profileImage = json['profileImage'] ?? constants.defaultImage;
    commentText = json['commentText'];
    var dateTimeParse = DateTime.parse(json['dateTime']);
    dateTime =
        DateFormat.yMMMd().addPattern("'a't h:m a").format(dateTimeParse);
  }
  Map<String, dynamic> toMap() {
    return {
      if (name != '') 'name': name,
      if (profileImage != '') 'profileImage': profileImage,
      if (commentText != '') 'commentText': commentText,
      if (dateTime != '') 'dateTime': dateTime,
    };
  }
}
