import 'package:intl/intl.dart';

class MessagesModel {
  String senderId = '';
  String reciverId = '';
  String message = '';
  String dateTime = '';
  String image = '';

  MessagesModel({
    required this.senderId,
    required this.reciverId,
    required this.message,
    required this.dateTime,
    this.image = '',
  });

  MessagesModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    reciverId = json['reciverId'];
    message = json['message'];
    image = json['image'] ?? '';
    var dateTimeParse = DateTime.parse(json['dateTime']);
    dateTime =
        DateFormat.yMMMd().addPattern("'a't h:m a").format(dateTimeParse);
  }
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'reciverId': reciverId,
      'message': message,
      if (image != '') 'image': image,
      'dateTime': dateTime,
    };
  }
}
