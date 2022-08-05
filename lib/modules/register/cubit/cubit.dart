import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model/user_model.dart';
import 'package:social_app/modules/register/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());
  static RegisterCubit get(context) => BlocProvider.of(context);
  bool isPassword = true;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    emit(RegisterPasswordVisisbilityChangeState());
  }

  Future register(
      {required name,
      required email,
      required phone,
      required password,
      required context}) async {
    emit(RegisterLoadingState());
    try {
      return await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        if (value.user != null) {
          uId = value.user!.uid.toString();

          CacheHelper.setData('uId', value.user?.uid.toString());
          CacheHelper.setData('isVerified', value.user?.emailVerified);
          uId = value.user!.uid.toString();
          isVerified = value.user?.emailVerified;
          createUser(
              name: name,
              phone: phone,
              email: email,
              uId: value.user!.uid.toString());
          print(uId);
          showToast('Registered Succesfully.', ToastState.success);
          emit(RegisterSuccessState());
        } else {
          emit(RegisterErrorState());
        }
      }).catchError((e) {
        try {
          print(e.message.toString());
          showToast(e.message.toString(), ToastState.error);
        } catch (e) {
          print(e.toString());
          showToast(e.toString(), ToastState.error);
        }

        emit(RegisterErrorState());
        return null;
      });
    } catch (e) {
      print(e.toString());
      return Future.value(null);
      // showToast(e.toString(), ToastState.error);
      // emit(LoginErrorState());
    }
  }

  void createUser({
    required String name,
    required String email,
    required String phone,
    required String uId,
    String cover = defaultCover,
    String image = defaultImage,
    String bio = defaultBio,
  }) {
    UserModel userData = UserModel(
        name: name,
        email: email,
        phone: phone,
        uId: uId,
        cover: cover,
        image: image,
        bio: bio);

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(userData.toMap());
  }
}
