import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeLayoutStates>(
      listener: (conetxt, state) {
        if (state is HomeUploadDataSuccessState) {
          showToast('Edited Profile Succesfully.', ToastState.success);
          Navigator.pop(context);
        }
      },
      builder: (conetxt, state) {
        var model = HomeCubit.get(context).userDataModel;
        var cubit = HomeCubit.get(context);
        if (nameController.text.isEmpty) nameController.text = model.name;
        if (bioController.text.isEmpty) bioController.text = model.bio;
        return Scaffold(
          appBar: defaultAppBar(context: conetxt, title: 'Edit Profile'),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    if (state is HomeUploadDataLoadingState)
                      const LinearProgressIndicator(),
                    if (state is HomeUploadImageLoadingState)
                      LinearProgressIndicator(
                        value: state.percentage == null
                            ? null
                            : (state.percentage! / 100),
                      ),
                    if (state is HomeUploadDataLoadingState ||
                        state is HomeUploadImageLoadingState)
                      const SizedBox(
                        height: 5,
                      ),
                    //Cover and profile image
                    SizedBox(
                      height: 190,
                      child: Stack(
                        alignment: AlignmentDirectional.topCenter,
                        children: [
                          //Cover
                          Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                topLeft: Radius.circular(5),
                              ),
                            ),
                            child: cubit.coverImage != null
                                ? Image(
                                    height: 140,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    image: FileImage(cubit.coverImage!))
                                : CachedNetworkImage(
                                    height: 140,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    imageUrl: model.cover),
                          ),
                          //Camera Icon
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  cubit.coverImage != null
                                      ? defaultCloseButton(
                                          onTap: () => cubit
                                              .cancelImage(ImageType.cover),
                                        )
                                      : const SizedBox(),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        cubit.selectImage(ImageType.cover);
                                      },
                                      child: const CircleAvatar(
                                          radius: 18,
                                          child: Icon(IconBroken.Camera))),
                                ],
                              ),
                            ),
                          ),
                          //Profile Picture
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
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          cubit.profileImage != null
                                              ? FileImage(cubit.profileImage!)
                                              : CachedNetworkImageProvider(
                                                  model.image) as ImageProvider,
                                    ),
                                    //Camera Icon

                                    cubit.profileImage != null
                                        ? defaultCloseButton(
                                            onTap: () => cubit
                                                .cancelImage(ImageType.profile))
                                        : InkWell(
                                            onTap: () {
                                              cubit.selectImage(
                                                  ImageType.profile);
                                            },
                                            child: const CircleAvatar(
                                                radius: 18,
                                                child:
                                                    Icon(IconBroken.Camera))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    defaultTextFormField(
                        textController: nameController,
                        validator: (value) {
                          if (value == null || value.trim() == '') {
                            return 'Please Enter Your Name.';
                          } else {
                            return null;
                          }
                        },
                        labelText: 'Name',
                        prefixIcon: IconBroken.User),
                    const SizedBox(
                      height: 10,
                    ),
                    defaultTextFormField(
                        textController: bioController,
                        validator: (value) {
                          if (value == null || value.trim() == '') {
                            return 'Please Enter Some Text.';
                          } else {
                            return null;
                          }
                        },
                        labelText: 'Bio',
                        prefixIcon: IconBroken.Info_Circle),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              cubit.uploadProfile(
                                name: nameController.text,
                                bio: bioController.text,
                              );
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Update'),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(IconBroken.Edit_Square)
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
