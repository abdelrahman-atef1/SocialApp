import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

Widget defaultTextFormField(
    {required TextEditingController textController,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    void Function(String)? onFieldSubmitted,
    void Function(String)? onChanged,
    required String? Function(String?)? validator,
    required String labelText,
    required IconData prefixIcon,
    Widget? suffixIcon,
    void Function()? onTap,
    bool isDarkMode = false,
    TextDirection textDirection = TextDirection.ltr}) {
  return TextFormField(
    controller: textController,
    keyboardType: keyboardType,
    obscureText: isPassword,
    onFieldSubmitted: onFieldSubmitted,
    onChanged: onChanged,
    validator: validator,
    onTap: onTap,
    textDirection: textDirection,
    decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
        contentPadding: const EdgeInsets.all(15),
        suffixIcon: suffixIcon,
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black12, width: 1.0),
        )),
  );
}

void navigatTo(
    {required BuildContext context,
    required Widget screen,
    bool replace = true}) {
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => screen), (route) => !replace);
}

enum ToastState { error, success, warning }
Color toastColor(ToastState state) {
  switch (state) {
    case ToastState.error:
      return Colors.red;
    case ToastState.success:
      return Colors.green;
    case ToastState.warning:
      return Colors.amber;
    default:
      return Colors.green;
  }
}

void showToast(String message, ToastState state) {
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: toastColor(state),
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
  );
}

void logOut(context) async {
  uId = '';
  isVerified = null;
  var cubit = HomeCubit.get(context);
  cubit.userDataModel.uId = '';
  cubit.userDataModel.email = '';
  cubit.userDataModel.phone = '';
  cubit.userDataModel.name = '';
  cubit.userDataModel.cover = '';
  cubit.userDataModel.image = '';
  cubit.userDataModel.bio = '';
  cubit.messages = [];
  cubit.users = [];
  cubit.appLaunched = false;
  await CacheHelper.setData('uId', '');
  await FirebaseAuth.instance.signOut();
  navigatTo(context: context, screen: LoginScreen());
}

AppBar defaultAppBar(
    {required BuildContext context,
    Color backGroundColor = Colors.white,
    Color? iconColor,
    String? title,
    List<Widget>? actions,
    Widget afterTitle = const SizedBox()}) {
  return AppBar(
    backgroundColor: backGroundColor,
    titleSpacing: 5,
    leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(
          IconBroken.Arrow___Left_2,
          color: iconColor,
        )),
    title: Row(
      children: [
        if (title != null)
          Text(
            title,
            style: const TextStyle(color: Colors.black),
          ),
        afterTitle,
      ],
    ),
    actions: actions,
  );
}

Widget defaultCloseButton({void Function()? onTap, double radius = 18}) {
  return InkWell(
      onTap: onTap,
      child: CircleAvatar(
          backgroundColor: Colors.black.withOpacity(0.4),
          radius: radius,
          child: Icon(
            Icons.close,
            color: Colors.white,
            size: radius * 1.4,
          )));
}

Widget nothingYet() {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Text('Nothing here yet.',
            style: TextStyle(
              fontSize: 24,
            )),
        Icon(
          Icons.error_outline_rounded,
          size: 45,
        )
      ],
    ),
  );
}
