abstract class HomeLayoutStates {}

class HomeInitialState extends HomeLayoutStates {}

class HomeVerifySuccessState extends HomeLayoutStates {}

class HomeVerifyErrorState extends HomeLayoutStates {}

class HomeChangeBottomNavBarState extends HomeLayoutStates {}

class HomeUploadPostState extends HomeLayoutStates {}

class HomeSelectProfileImageSuccessState extends HomeLayoutStates {}

class HomeSelectProfileImageErrorState extends HomeLayoutStates {}

class HomeSelectCoverImageSuccessState extends HomeLayoutStates {}

class HomeSelectCoverImageErrorState extends HomeLayoutStates {}

class HomeCancelImageState extends HomeLayoutStates {}

class HomeUploadProfileImageSuccessState extends HomeLayoutStates {}

class HomeUploadProfileImageErrorState extends HomeLayoutStates {}

class HomeUploadCoverImageSuccessState extends HomeLayoutStates {}

class HomeUploadCoverImageErrorState extends HomeLayoutStates {}

class HomeUploadDataSuccessState extends HomeLayoutStates {}

class HomeUploadDataErrorState extends HomeLayoutStates {}

class HomeUploadDataLoadingState extends HomeLayoutStates {}

class HomeUploadImageLoadingState extends HomeLayoutStates {
  int? percentage;
  HomeUploadImageLoadingState(this.percentage);
}

class HomeUploadImageSuccessState extends HomeLayoutStates {}

class HomeUploadImageErrorState extends HomeLayoutStates {}

class HomeCreatePostLoadingState extends HomeLayoutStates {}

class HomeCreatePostSuccessState extends HomeLayoutStates {}

class HomeCreatePostErrorState extends HomeLayoutStates {}

class HomeGetPostsLoadingState extends HomeLayoutStates {}

class HomeGetPostsSuccessState extends HomeLayoutStates {}

class HomeGetPostsErrorState extends HomeLayoutStates {}

class HomeLikePostSuccessState extends HomeLayoutStates {}

class HomeLikePostErrorState extends HomeLayoutStates {}

class HomeCommentSuccessState extends HomeLayoutStates {}

class HomeCommentErrorState extends HomeLayoutStates {}

class HomeGetCommentsSuccessState extends HomeLayoutStates {}

class HomeGetCommentsLoadingState extends HomeLayoutStates {}

class HomeGetCommentsErrorState extends HomeLayoutStates {}

class HomeGetUsersSuccessState extends HomeLayoutStates {}

class HomeGetUsersLoadingState extends HomeLayoutStates {}

class HomeGetUsersErrorState extends HomeLayoutStates {}

class HomeSendMessageSuccessState extends HomeLayoutStates {}

class HomeSendMessageLoadingState extends HomeLayoutStates {}

class HomeSendMessageErrorState extends HomeLayoutStates {}

class HomeGetMessagesSuccessState extends HomeLayoutStates {}

class HomeGetMessagesLoadingState extends HomeLayoutStates {}
