import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/modules/login/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());
  static LoginCubit get(context) => BlocProvider.of(context);
  bool isPassword = true;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    emit(LoginPasswordVisisbilityChangeState());
  }

  Future<dynamic> login(
      {required email, required password, required context}) async {
    emit(LoginLoadingState());

    var _isVerified = FirebaseAuth.instance.currentUser?.emailVerified;
    if (_isVerified == null || _isVerified == false) {
      UserCredential u = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .catchError((e) {
        print(e.message.toString());
        showToast(e.message.toString(), ToastState.error);
        emit(LoginErrorState());
      });
      try {
        if (u.user != null) {
          await CacheHelper.setData('uId', u.user?.uid.toString());
          await CacheHelper.setData('isVerified', u.user?.emailVerified);
          isVerified = u.user?.emailVerified;
          uId = u.user!.uid;
          await HomeCubit.get(context).getUserData();
          // await HomeCubit.get(context).getPosts().then((u) {
          //   print(u);
          // });
          emit(LoginSuccessState());
        }
      } catch (e) {
        try {
          print(e.toString());
          showToast(e.toString(), ToastState.error);
        } catch (e) {
          print(e.toString());
          showToast(networkErrorMessage, ToastState.error);
        }
        emit(LoginErrorState());
      }
    } else {
      CacheHelper.setData('isVerified', _isVerified);
    }

    return null;
  }
}
