import 'package:firebase_auth/firebase_auth.dart';

String uId = '';
bool? isVerified = false;
String networkErrorMessage =
    'Error occured while trying to connect, please check your connection and try again.';
User? loggedUser;
const String defaultCover =
    'https://img.freepik.com/free-photo/ramadan-kareem-blog-banner-with-greeting_53876-128624.jpg';
const String defaultImage =
    'https://www.nicepng.com/png/detail/128-1280406_view-user-icon-png-user-circle-icon-png.png';
const String defaultBio = 'Available';

String defaultProfileImageDirectory(String localPath) =>
    'users/${uId + 'Profile' + (localPath).split('.').last}';
String defaultCoverImageDirectory(String localPath) =>
    'users/${uId + 'Cover' + (localPath).split('.').last}';
String defaultPostImageDirectory(String localPath) =>
    'posts/${uId + '/' + DateTime.now().toString() + (localPath).split('.').last}';

String defaultMessageImageDirectory(String localPath) =>
    'messages/${uId + '/' + DateTime.now().toString() + (localPath).split('.').last}';
