import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/modules/comments/comments_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:like_button/like_button.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeLayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Expanded(
          child: RefreshIndicator(
            onRefresh: () {
              return cubit.getPosts();
            },
            child: cubit.posts.isNotEmpty
                ? ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Card(
                        elevation: 5,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            height: 200,
                            //width: double.infinity,
                            imageUrl:
                                'https://img.freepik.com/free-vector/online-world-concept-illustration_114360-1007.jpg'),
                      ),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 4,
                        ),
                        shrinkWrap: true,
                        itemBuilder: ((context, index) {
                          return postBuilder(
                              context: context, cubit: cubit, index: index);
                        }),
                        itemCount: cubit.posts.length,
                      ),
                    ],
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  Widget postBuilder(
      {required HomeCubit cubit,
      required BuildContext context,
      required int index}) {
    var postModel = cubit.posts[index];
    return Card(
      elevation: 5,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //userData
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: CachedNetworkImageProvider(
                      postModel.profileImage,
                      maxHeight: 100),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              postModel.name,
                              style: const TextStyle(
                                  height: 1.2, overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Icon(
                            Icons.check_circle,
                            size: 15,
                            color: mainColor,
                          )
                        ],
                      ),
                      Text(
                        postModel.dateTime,
                        style: Theme.of(context).textTheme.caption?.copyWith(
                              height: 1.2,
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz))
              ],
            ),
            const Divider(),
            Text(postModel.postText, style: const TextStyle(height: 1.6)),
            //# tags
            // Container(
            //   padding: const EdgeInsetsDirectional.only(end: 5),
            //   height: 25,
            //   child: TextButton(
            //     style: TextButton.styleFrom(
            //         padding: EdgeInsets.zero,
            //         minimumSize: const Size(0, 0),
            //         alignment: Alignment.centerLeft),
            //     child: Text(
            //       '#software#media#social',
            //       style: TextStyle(color: mainColor, height: 1.6),
            //       maxLines: 2,
            //       overflow: TextOverflow.ellipsis,
            //     ),
            //     onPressed: () {},
            //   ),
            // ),
            // Container(
            //   padding: const EdgeInsetsDirectional.only(end: 5),
            //   height: 25,
            //   child: TextButton(
            //     style: TextButton.styleFrom(
            //         padding: EdgeInsets.zero,
            //         minimumSize: const Size(0, 0),
            //         alignment: Alignment.centerLeft),
            //     child: Text(
            //       '#software#media#social',
            //       style: TextStyle(color: mainColor, height: 1.6),
            //       maxLines: 2,
            //       overflow: TextOverflow.ellipsis,
            //     ),
            //     onPressed: () {},
            //   ),
            // ),
            // Container(
            //   padding: const EdgeInsetsDirectional.only(end: 5),
            //   height: 25,
            //   child: TextButton(
            //     style: TextButton.styleFrom(
            //         padding: EdgeInsets.zero,
            //         minimumSize: const Size(0, 0),
            //         alignment: Alignment.centerLeft),
            //     child: Text(
            //       '#software#media#social',
            //       style: TextStyle(color: mainColor, height: 1.6),
            //       maxLines: 2,
            //       overflow: TextOverflow.ellipsis,
            //     ),
            //     onPressed: () {},
            //   ),
            // ),
            // Container(
            //   padding: const EdgeInsetsDirectional.only(end: 5),
            //   height: 25,
            //   child: TextButton(
            //     style: TextButton.styleFrom(
            //         padding: EdgeInsets.zero,
            //         minimumSize: const Size(0, 0),
            //         alignment: Alignment.centerLeft),
            //     child: Text(
            //       '#software#media#social',
            //       style: TextStyle(color: mainColor, height: 1.6),
            //       maxLines: 2,
            //       overflow: TextOverflow.ellipsis,
            //     ),
            //     onPressed: () {},
            //   ),
            // ),
            if (postModel.postImage != '' && postModel.postImage != 'null')
              Padding(
                padding:
                    const EdgeInsetsDirectional.only(top: 4.0, bottom: 4.0),
                child: CachedNetworkImage(imageUrl: postModel.postImage!),
              ),
            //Count
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Likes Count
                  Expanded(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Row(
                          children: [
                            const Icon(
                              IconBroken.Heart,
                              color: Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              postModel.likes != null
                                  ? postModel.likes!.length.toString()
                                  : '0',
                              style: Theme.of(context).textTheme.caption,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  //Comments Count
                  Expanded(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Spacer(),
                            const Icon(
                              IconBroken.Chat,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${postModel.comments!.length > 1 ? postModel.comments!.length.toString() + ' Comments' : '${postModel.comments!.length.toString()} Comment'} ',
                              style: Theme.of(context).textTheme.caption,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            //Like & Comment Buttons
            Row(
              children: [
                //Comment
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[200]),
                    child: InkWell(
                      onTap: () {
                        navigatTo(
                            context: context,
                            screen: CommentsScreen(
                              postId: postModel.postId,
                              postIndex: index,
                            ),
                            replace: false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundImage: CachedNetworkImageProvider(
                                  cubit.userDataModel.image,
                                  maxHeight: 60),
                            ),
                            const SizedBox(width: 5),
                            Text('Write a comment ...',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    ?.copyWith(fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                //Like
                SizedBox(
                  width: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LikeButton(
                        size: 25,
                        animationDuration: const Duration(milliseconds: 1500),
                        isLiked: postModel.isLiked,
                        onTap: (isLiked) {
                          cubit.addLike(postModel.postId, isLiked, index);
                          print(postModel.likes);
                          return Future.value(!isLiked);
                        },
                      ),
                      Text(
                        'Like',
                        style: Theme.of(context).textTheme.caption,
                      )
                    ],
                  ),
                  // child: IconButton(
                  //     onPressed: () {
                  //       cubit.addLike(postModel.postId);
                  //       print(postModel.likes);
                  //     },
                  //     icon: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         Icon(
                  //           postModel.isLiked
                  //               ? IconBroken.Heart
                  //               : Icons.wrong_location,
                  //           color: Colors.red,
                  //           size: 20,
                  //         ),
                  //         const SizedBox(width: 5),
                  //         Text(
                  //           'Like',
                  //           style: Theme.of(context).textTheme.caption,
                  //         )
                  //       ],
                  //     )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
