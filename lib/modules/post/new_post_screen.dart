import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class NewPostScreen extends StatelessWidget {
  NewPostScreen({Key? key}) : super(key: key);
  final TextEditingController textController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeLayoutStates>(
      listener: (context, state) {
        if (state is HomeCreatePostSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: ((context, state) {
        // var isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
        var cubit = HomeCubit.get(context);
        return Scaffold(
          appBar:
              defaultAppBar(context: context, title: 'Create Post', actions: [
            TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    cubit.createPost(postText: textController.text);
                  }
                },
                child: const Text('Publish'))
          ]),
          body: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  if (state is HomeCreatePostLoadingState)
                    const LinearProgressIndicator(),
                  if (state is HomeUploadImageLoadingState)
                    LinearProgressIndicator(
                      value: state.percentage == null
                          ? null
                          : (state.percentage! / 100),
                    ),
                  if (state is HomeUploadImageLoadingState ||
                      state is HomeCreatePostLoadingState)
                    const SizedBox(
                      height: 8,
                    ),
                  //user data
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: CachedNetworkImageProvider(
                            cubit.userDataModel.image),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        child: Text(
                          cubit.userDataModel.name,
                          style: const TextStyle(
                              height: 1.2, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  //Text Input
                  Form(
                    key: formKey,
                    child: TextFormField(
                        controller: textController,
                        keyboardType: TextInputType.multiline,
                        maxLength: 500,
                        minLines: 1,
                        maxLines: 7,
                        validator: (value) {
                          if (textController.text.isEmpty) {
                            return 'Enter some text to post.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText:
                              'What is in your mind,${cubit.userDataModel.name.split(' ').first}',
                          //contentPadding: const EdgeInsets.all(15),
                          border: InputBorder.none,
                        )),
                  ),

                  if (cubit.postImage != null)
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(cubit.postImage!)),
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        defaultCloseButton(
                            onTap: () => cubit.cancelImage(ImageType.post)),
                      ],
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                      onPressed: () async {
                        await cubit.selectImage(ImageType.post);
                        // cubit.uploadImage(
                        //     imageType: ImageType.post,
                        //     directory: 'users/test.jpg');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(IconBroken.Image),
                          SizedBox(
                            width: 5,
                          ),
                          Text('Add Photo')
                        ],
                      )),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: OutlinedButton(
                        onPressed: () {}, child: const Text('# Tags'))),
              ],
            ),
          ),
        );
      }),
    );
  }
}
