import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/modules/post/new_post_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('Do you want to exit the App'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Builder(builder: (context) {
        if (!HomeCubit.get(context).appLaunched) {
          HomeCubit.get(context).launchApp();
        }
        return BlocConsumer<HomeCubit, HomeLayoutStates>(
          listener: (context, state) {
            if (state is HomeUploadPostState) {
              navigatTo(
                  context: context, screen: NewPostScreen(), replace: false);
            }
            if (state is HomeInitialState) {
              isVerified = CacheHelper.getData('isVerified');
            }
            //print(FirebaseAuth.instance.currentUser!.emailVerified.toString());
            //print(isVerified);
          },
          builder: (context, state) {
            var cubit = HomeCubit.get(context);
            return Scaffold(
                appBar: AppBar(
                  title: Text(
                    cubit.titles[cubit.selectedIndex > 2
                        ? cubit.selectedIndex - 1
                        : cubit.selectedIndex],
                    style: const TextStyle(color: Colors.black),
                  ),
                  actions: [
                    const Icon(IconBroken.Notification),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(IconBroken.Search),
                    const SizedBox(
                      width: 10,
                    ),
                    if (cubit.selectedIndex == 4)
                      TextButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsetsDirectional.fromSTEB(
                                      0, 10, 5, 10))),
                          onPressed: () => logOut(context),
                          child: const Text('LogOut')),
                  ],
                ),
                bottomNavigationBar: Theme(
                  data: Theme.of(context).copyWith(
                    // sets the background color of the `BottomNavigationBar`
                    canvasColor: Colors.white,
                  ),
                  child: BottomNavigationBar(
                    onTap: (index) => cubit.changeBottomNavBar(index),
                    currentIndex: cubit.selectedIndex,
                    items: const [
                      BottomNavigationBarItem(
                          icon: Icon(IconBroken.Home), label: 'Home'),
                      BottomNavigationBarItem(
                          icon: Icon(IconBroken.Chat), label: 'Chats'),
                      BottomNavigationBarItem(
                          icon: Icon(IconBroken.Paper_Upload),
                          label: 'New Post'),
                      BottomNavigationBarItem(
                          icon: Icon(IconBroken.Location), label: 'Users'),
                      BottomNavigationBarItem(
                          icon: Icon(IconBroken.Setting), label: 'Settings'),
                    ],
                  ),
                ),
                body: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (isVerified == null || isVerified == false)
                      Container(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
                        color: Colors.amber.withOpacity(0.6),
                        width: double.infinity,
                        child: Row(children: [
                          const Icon(Icons.info_outline),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text('Please verify your account'),
                          const Spacer(),
                          TextButton(
                              onPressed: () {
                                HomeCubit.get(context).verify();
                              },
                              child: const Text('SEND'))
                        ]),
                      ),
                    cubit.screens[cubit.selectedIndex > 2
                        ? cubit.selectedIndex - 1
                        : cubit.selectedIndex]
                  ],
                ));
          },
        );
      }),
    );
  }
}
