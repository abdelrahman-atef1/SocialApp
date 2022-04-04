import 'package:social_app/shared/components/constants.dart';

class UserModel {
  String name = '';
  String email = '';
  String phone = '';
  String uId = '';
  String cover = '';
  String image = '';
  String bio = '';
  UserModel({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.uId = '',
    this.cover = defaultCover,
    this.image = defaultImage,
    this.bio = defaultBio,
  });
  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'].toString();
    email = json['email'].toString();
    phone = json['phone'].toString();
    uId = json['uId'].toString();
    cover = json['cover'] ?? defaultCover;
    image = json['image'] ?? defaultImage;
    bio = json['bio'] ?? defaultBio;
  }
  Map<String, dynamic> toMap() {
    return {
      if (name != '') 'name': name,
      if (email != '') 'email': email,
      if (phone != '') 'phone': phone,
      if (uId != '') 'uId': uId,
      if (cover != '') 'cover': cover,
      if (image != '') 'image': image,
      if (bio != '') 'bio': bio,
    };
  }
}
