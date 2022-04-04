import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  var token = await FirebaseMessaging.instance.getToken();
  print(token);
  FirebaseMessaging.onMessage.listen((event) {
    showToast('Forground Message Handled Successfully.', ToastState.success);
    print(event.data);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    showToast('Open App Message Handled Successfully.', ToastState.success);
    print(event.data);
  });
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
  BlocOverrides.runZoned(
    () {
      // Use cubits...
      runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}

Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  showToast('Background Message Handled Successfully.', ToastState.success);
  print(message);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HttpOverrides.global = MyHttpOverrides();

    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => HomeCubit()..launchApp())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Socail App',
        theme: lightTheme,
        home: currentScreen(),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Widget currentScreen() {
  String? cachedUid = CacheHelper.getData('uId');
  if (cachedUid != null && cachedUid != '') {
    uId = cachedUid;
    return const HomeLayout();
  } else {
    return LoginScreen();
  }
}
