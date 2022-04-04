import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/modules/chat/chat_details.dart';
import 'package:social_app/shared/components/components.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key, postId, postIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeLayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Expanded(
          child: RefreshIndicator(
            onRefresh: () {
              return cubit.getUsers();
            },
            child: cubit.users.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.separated(
                    separatorBuilder: ((context, index) => const Divider()),
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemCount: cubit.users.length,
                    itemBuilder: ((context, index) {
                      var currentUser = HomeCubit.get(context).users[index];

                      return InkWell(
                        onTap: () {
                          navigatTo(
                              context: context,
                              screen: ChatDetails(
                                reciverModel: currentUser,
                              ),
                              replace: false);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: CachedNetworkImageProvider(
                                    currentUser.image,
                                    maxHeight: 100),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(currentUser.name)
                            ],
                          ),
                        ),
                      );
                    })),
          ),
        );
      },
    );
  }
}
