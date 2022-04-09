import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/modules/edit_profile/edit_profile_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeLayoutStates>(
      listener: (conetxt, state) {},
      builder: (conetxt, state) {
        var model = HomeCubit.get(context).userDataModel;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                //Cover and profile image
                SizedBox(
                  height: 190,
                  child: Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: [
                      Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            topLeft: Radius.circular(5),
                          ),
                        ),
                        child: CachedNetworkImage(
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          imageUrl: model.cover,
                          errorWidget: (context, url, error) {
                            return InkWell(
                              child: const Icon(Icons
                                  .signal_wifi_connected_no_internet_4_outlined),
                              onTap: () => HomeCubit.get(context).getUserData(),
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 53,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                            ),
                            CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  CachedNetworkImageProvider(model.image),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                //User name and authentication Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      model.name.toString(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    if (CacheHelper.getData('isVerified'))
                      Icon(
                        Icons.check_circle,
                        color: mainColor,
                        size: 15,
                      )
                  ],
                ),
                //Bio
                Text(
                  model.bio.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                ),
                const SizedBox(
                  height: 10,
                ),
                //User States and numbers
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                          onPressed: () {},
                          child: Column(
                            children: [
                              Text(
                                '155',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text('Posts',
                                  style: Theme.of(context).textTheme.caption),
                            ],
                          )),
                    ),
                    Expanded(
                      child: TextButton(
                          onPressed: () {},
                          child: Column(
                            children: [
                              Text(
                                '50',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text('Photos',
                                  style: Theme.of(context).textTheme.caption),
                            ],
                          )),
                    ),
                    Expanded(
                      child: TextButton(
                          onPressed: () {},
                          child: Column(
                            children: [
                              Text(
                                '100k',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text('Followers',
                                  style: Theme.of(context).textTheme.caption),
                            ],
                          )),
                    ),
                    Expanded(
                      child: TextButton(
                          onPressed: () {},
                          child: Column(
                            children: [
                              Text(
                                '500',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              Text('Following',
                                  style: Theme.of(context).textTheme.caption),
                            ],
                          )),
                    ),
                  ],
                ),
                //Edit profile Button
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Edit Profile'),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(IconBroken.Edit),
                          ],
                        ),
                        onPressed: () {
                          navigatTo(
                              context: context,
                              screen: EditProfileScreen(),
                              replace: false);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
