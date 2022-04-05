import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/comments_model/post_model.dart';
import 'package:social_app/models/messages_model/messages_model.dart';
import 'package:social_app/models/post_model/post_model.dart';
import 'package:social_app/models/user_model/user_model.dart';
import 'package:social_app/modules/chat/chat_screen.dart';
import 'package:social_app/modules/feed/feed_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

enum ImageType { cover, profile, post, message }

class HomeCubit extends Cubit<HomeLayoutStates> {
  HomeCubit() : super(HomeInitialState());
  static HomeCubit get(context) => BlocProvider.of(context);
  bool appLaunched = false;
  Future launchApp() async {
    appLaunched = true;
    await getUserData();
    getPosts();
    getUsers();
  }

  Future verify() async {
    try {
      var _isVerified = FirebaseAuth.instance.currentUser?.emailVerified;
      if (_isVerified == null || _isVerified == false) {
        return await FirebaseAuth.instance.currentUser!
            .sendEmailVerification()
            .then((value) {
          isVerified = true;
          CacheHelper.setData(
              'isVerified', FirebaseAuth.instance.currentUser!.emailVerified);
          showToast(
              'Email verification sent successfully, check your email to verify your account.',
              ToastState.success);
          emit(HomeVerifySuccessState());
        });
      } else {
        CacheHelper.setData('isVerified', _isVerified);
      }
    } catch (e) {
      print(e.toString());
      showToast(networkErrorMessage, ToastState.error);
      emit(HomeVerifyErrorState());
    }
  }

  List<Widget> screens = [
    const FeedScreen(),
    const ChatScreen(),
    const UsersScreen(),
    const SettingsScreen()
  ];
  List<String> titles = ['News Feed', 'Chat', 'Users', 'Settings'];
  int selectedIndex = 0;
  void changeBottomNavBar(int index) {
    if (index == 2) {
      emit(HomeUploadPostState());
    } else {
      selectedIndex = index;
      emit(HomeChangeBottomNavBarState());
    }
  }

  late UserModel userDataModel;
  Future getUserData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId.toString())
        .get()
        .then((value) {
      print(value.data().toString());
      return userDataModel = UserModel.fromJson(value.data()!);
    });
  }

  final ImagePicker _picker = ImagePicker();
  File? coverImage;
  File? profileImage;
  File? postImage;
  File? messageImage;
  Future selectImage(ImageType imageType) async {
    await _picker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        switch (imageType) {
          case ImageType.cover:
            coverImage = File(value.path);

            break;
          case ImageType.post:
            postImage = File(value.path);

            break;
          case ImageType.profile:
            profileImage = File(value.path);

            break;
          case ImageType.message:
            messageImage = File(value.path);

            break;
        }
      }
      emit(HomeSelectCoverImageSuccessState());
    }).catchError((e) => emit(HomeSelectCoverImageErrorState()));
  }

  Future uploadImage(
      {required String directory, required ImageType imageType}) async {
    emit(HomeUploadImageLoadingState(null));
    try {
      File file() {
        switch (imageType) {
          case ImageType.cover:
            return File(coverImage!.path);
          case ImageType.profile:
            return File(profileImage!.path);
          case ImageType.post:
            return File(postImage!.path);
          case ImageType.message:
            return File(messageImage!.path);
        }
      }

      var uploadTask = firebase_storage.FirebaseStorage.instance
          .ref()
          .child(directory)
          .putFile(file());
      uploadTask.snapshotEvents.listen((event) {
        int? percentage =
            ((event.bytesTransferred / event.totalBytes) * 100).round();
        print(percentage);
        if (percentage == 0) percentage = null;
        emit(HomeUploadImageLoadingState(percentage));
      });
      String? imageUrl = await uploadTask.then((snap) async {
        return await snap.ref.getDownloadURL();
      });
      switch (imageType) {
        case ImageType.cover:
          coverImageLink = imageUrl;
          break;
        case ImageType.profile:
          profileImageLink = imageUrl;
          break;
        case ImageType.post:
          postImageLink = imageUrl;
          break;
        case ImageType.message:
          messageImageLink = imageUrl;

          break;
      }
      emit(HomeUploadImageSuccessState());
    } catch (e) {
      print(e.toString());
      emit(HomeUploadImageErrorState());
    }
  }

  Future updateUserData(Map<String, dynamic> json) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .update(json);
      emit(HomeUploadDataSuccessState());
    } catch (e) {
      showToast(e.toString(), ToastState.error);
      emit(HomeUploadDataErrorState());
    }
  }

  UserModel? profileModel;
  Future getUserWithUid(String uid) async {
    try {
      var data =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (data.data() != null) {
        profileModel = UserModel.fromJson(data.data()!);
        return UserModel.fromJson(data.data()!);
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future createPost({
    required String postText,
  }) async {
    try {
      emit(HomeCreatePostLoadingState());
      if (postImage != null) {
        await uploadImage(
            directory: defaultPostImageDirectory(postImage!.path),
            imageType: ImageType.post);
      }
      PostModel postModel = PostModel(
          name: userDataModel.name,
          uId: userDataModel.uId,
          postText: postText,
          postImage: postImageLink,
          profileImage: userDataModel.image,
          dateTime: DateTime.now().toString());
      await FirebaseFirestore.instance
          .collection('posts')
          .add(postModel.toMap());
      postImage = null;
      postImageLink = null;
      posts = [];
      emit(HomeCreatePostSuccessState());
      await getPosts();
    } catch (e) {
      print(e.toString());
      emit(HomeCreatePostErrorState());
    }
  }

  List<PostModel> posts = [];
  Future getPosts() async {
    emit(HomeGetPostsLoadingState());
    try {
      var postsCollection = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('dateTime')
          .get();
      posts = [];

      for (var element in postsCollection.docs) {
        PostModel currentpost = PostModel.fromJson(element.data());

        //Add Likes to posts list
        var likesSnapshot = await FirebaseFirestore.instance
            .collection('posts')
            .doc(element.id)
            .collection('likes')
            .get();
        for (var element in likesSnapshot.docs) {
          if (element.id == uId) {
            currentpost.isLiked = true;
          }
          currentpost.likes?.add(element.id);
        }
        //Add comments to posts list
        try {
          var commentsSnapshot = await FirebaseFirestore.instance
              .collection('posts')
              .doc(element.id)
              .collection('comments')
              .orderBy('dateTime')
              .get();
          for (var element in commentsSnapshot.docs) {
            currentpost.comments?.add(CommentsModel.fromJson(element.data()));
          }
        } catch (e) {
          emit(HomeGetCommentsErrorState());
        }

        UserModel? userModel = await getUserWithUid(currentpost.uId);
        if (userModel != null) {
          currentpost.profileImage = userModel.image;
          currentpost.name = userModel.name;
        }
        currentpost.postId = element.id;
        posts.add(currentpost);
        //print(element.data());
      }
      emit(HomeGetPostsSuccessState());
    } catch (e) {
      print(e.toString());
      emit(HomeGetPostsErrorState());
    }
  }

  Future getComments(String postId, int postIndex) async {
    emit(HomeGetCommentsLoadingState());
    try {
      var commentsSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('dateTime')
          .get();
      posts[postIndex].comments = [];
      for (var element in commentsSnapshot.docs) {
        posts[postIndex].comments?.add(CommentsModel.fromJson(element.data()));
      }
      emit(HomeGetCommentsSuccessState());
    } catch (e) {
      emit(HomeGetCommentsErrorState());
    }
  }

  void uploadProfile({
    required String name,
    required String bio,
  }) async {
    emit(HomeUploadDataLoadingState());

    if (coverImage != null && profileImage != null) {
      await uploadImage(
          directory: defaultCoverImageDirectory(coverImage!.path),
          imageType: ImageType.cover);
      await uploadImage(
          directory: defaultProfileImageDirectory(profileImage!.path),
          imageType: ImageType.profile);
    } else if (coverImage != null) {
      await uploadImage(
          directory: defaultCoverImageDirectory(coverImage!.path),
          imageType: ImageType.cover);
    } else if (profileImage != null) {
      await uploadImage(
          directory: defaultProfileImageDirectory(profileImage!.path),
          imageType: ImageType.profile);
    }
    String pImage = profileImageLink ?? userDataModel.image;
    String cImage = coverImageLink ?? userDataModel.cover;
    var updateModel =
        UserModel(name: name, bio: bio, image: pImage, cover: cImage);
    await updateUserData(updateModel.toMap());
    //update local user model
    userDataModel = UserModel(
      name: updateModel.name,
      bio: updateModel.bio,
      cover: updateModel.cover,
      email: userDataModel.email,
      image: updateModel.image,
      phone: userDataModel.phone,
      uId: userDataModel.uId,
    );
    profileImage = null;
    profileImageLink = null;
    coverImage = null;
    coverImageLink = null;
  }

  String? coverImageLink;
  String? profileImageLink;
  String? postImageLink;
  String? messageImageLink;

  Future addLike(String postId, bool isLiked, int index) async {
    if (isLiked) {
      try {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('likes')
            .doc(uId)
            .delete();
        posts[index].isLiked = !isLiked;
        posts[index].likes?.remove(uId);
        emit(HomeLikePostSuccessState());
      } catch (e) {
        showToast(e.toString(), ToastState.error);
        emit(HomeLikePostErrorState());
      }
    } else {
      try {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('likes')
            .doc(uId)
            .set({'liked': !isLiked});
        posts[index].isLiked = !isLiked;
        posts[index].likes?.add(uId);
        emit(HomeLikePostSuccessState());
      } catch (e) {
        showToast(e.toString(), ToastState.error);
        emit(HomeLikePostErrorState());
      }
    }
  }

  Future addComment(String postId, String commentText) async {
    try {
      CommentsModel comment = CommentsModel(
          name: userDataModel.name,
          profileImage: userDataModel.image,
          dateTime: DateTime.now().toString(),
          commentText: commentText);
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .add(comment.toMap());
      emit(HomeCommentSuccessState());
    } catch (e) {
      showToast(e.toString(), ToastState.error);
      emit(HomeCommentErrorState());
    }
  }

  void cancelImage(ImageType imageType) {
    switch (imageType) {
      case ImageType.cover:
        coverImage = null;
        coverImageLink = null;
        break;
      case ImageType.profile:
        profileImage = null;
        profileImageLink = null;
        break;
      case ImageType.post:
        postImage = null;
        postImageLink = null;
        break;
      case ImageType.message:
        messageImage = null;
        messageImageLink = null;
        break;
    }
    emit(HomeCancelImageState());
  }

  List<UserModel> users = [];
  Future getUsers() async {
    try {
      emit(HomeGetUsersLoadingState());
      users = [];
      var usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      for (var element in usersSnapshot.docs) {
        var data = UserModel.fromJson(element.data());
        if (data.uId != userDataModel.uId) {
          users.add(data);
        }
      }
      emit(HomeGetUsersSuccessState());
    } catch (e) {
      print(e.toString());
      emit(HomeGetUsersErrorState());
    }
  }

  Future sendMessage(
      {required String reciverId, required String message}) async {
    emit(HomeSendMessageLoadingState());
    MessagesModel messagesModel = MessagesModel(
        senderId: userDataModel.uId,
        reciverId: reciverId,
        message: message,
        image: messageImageLink ?? '',
        dateTime: DateTime.now().toString());
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userDataModel.uId)
          .collection('chats')
          .doc(reciverId)
          .collection('messages')
          .add(messagesModel.toMap());
      await FirebaseFirestore.instance
          .collection('users')
          .doc(reciverId)
          .collection('chats')
          .doc(userDataModel.uId)
          .collection('messages')
          .add(messagesModel.toMap());

      emit(HomeSendMessageSuccessState());
    } catch (e) {
      print(e.toString());
      emit(HomeSendMessageErrorState());
    }
  }

  List<MessagesModel> messages = [];
  void getMessages(reciverId) {
    emit(HomeGetMessagesLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userDataModel.uId)
        .collection('chats')
        .doc(reciverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];

      for (var element in event.docs) {
        messages.add(MessagesModel.fromJson(element.data()));
      }

      emit(HomeGetMessagesSuccessState());
    });
  }
}
