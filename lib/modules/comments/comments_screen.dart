import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class CommentsScreen extends StatelessWidget {
  final String postId;
  final int postIndex;

  CommentsScreen({Key? key, required this.postId, required this.postIndex})
      : super(key: key);
  final TextEditingController commentController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var isComments = false;

    return BlocConsumer<HomeCubit, HomeLayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        var currentPost = HomeCubit.get(context).posts[postIndex];
        if (!isComments) cubit.getComments(currentPost.postId, postIndex);
        isComments = true;

        return Scaffold(
          appBar: defaultAppBar(context: context, title: 'Comments'),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: state is HomeGetCommentsLoadingState
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if (currentPost.comments != null)
                        Expanded(
                          child: currentPost.comments!.isNotEmpty
                              ? ListView.separated(
                                  itemBuilder: (context, index) {
                                    var commentsModel =
                                        currentPost.comments![index];
                                    return Row(
                                      children: [
                                        //profile pictre
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  commentsModel.profileImage),
                                        ),

                                        const SizedBox(
                                          width: 8,
                                        ),
                                        //Comment Container
                                        Wrap(children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        commentsModel.name,
                                                        style: const TextStyle(
                                                            height: 1.2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
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
                                                  commentsModel.commentText,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      height: 1.2,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                                Text(
                                                  commentsModel.dateTime,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption
                                                      ?.copyWith(
                                                        height: 1.2,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const Divider(),
                                  itemCount: currentPost.comments!.length)
                              : Container(),
                        ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundImage: CachedNetworkImageProvider(
                                cubit.userDataModel.image),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8)),
                                child: Form(
                                  key: formKey,
                                  child: TextFormField(
                                    cursorHeight: 20,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.only(top: 8),
                                        border: InputBorder.none,
                                        prefixIcon: const Icon(
                                          IconBroken.Chat,
                                          size: 25,
                                        ),
                                        label: const Text(
                                          'Comment',
                                        ),
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                cubit.addComment(postId,
                                                    commentController.text);
                                                commentController.text = '';
                                                cubit.getComments(
                                                    currentPost.postId,
                                                    postIndex);
                                              }
                                            },
                                            icon: Icon(
                                              IconBroken.Send,
                                              color: mainColor,
                                            ))),
                                    controller: commentController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter some text to comment';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
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
