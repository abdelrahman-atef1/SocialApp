import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/user_model/user_model.dart';
import 'package:social_app/modules/chat/image_viewer.dart';
import 'package:social_app/modules/profile/profile_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class ChatDetails extends StatelessWidget {
  final UserModel reciverModel;
  ChatDetails({Key? key, required this.reciverModel}) : super(key: key);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    HomeCubit.get(context).getMessages(reciverModel.uId);
    print('get messages');
    return WillPopScope(
      onWillPop: () {
        HomeCubit.get(context).messageImage = null;
        HomeCubit.get(context).messageImageLink = null;
        return Future.value(true);
      },
      child:
          BlocConsumer<HomeCubit, HomeLayoutStates>(listener: (context, state) {
        //delete text if sent message
        if (state is HomeSendMessageSuccessState) {
          messageController.text = '';
          goTOEnd();
        }
      }, builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            afterTitle: Expanded(
              child: InkWell(
                onTap: () {
                  navigatTo(
                      context: context,
                      screen: ProfileScreen(
                        model: cubit.users.singleWhere(
                            (element) => element.uId == reciverModel.uId),
                      ),
                      replace: false);
                },
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 5, 5),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: CachedNetworkImageProvider(
                            reciverModel.image,
                            maxHeight: 100),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(reciverModel.name,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis)),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: state is HomeGetMessagesLoadingState
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 5),
                  child: Column(
                    children: [
                      //Chat List
                      Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            controller: scrollController,
                            physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics()),
                            itemBuilder: ((context, index) {
                              var currentMessage = cubit.messages.isNotEmpty
                                  ? cubit.messages[
                                      index == cubit.messages.length
                                          ? index - 1
                                          : index]
                                  : null;
                              if (index == cubit.messages.length) {
                                return Container(height: 10);
                              } else if (currentMessage!.senderId ==
                                  cubit.userDataModel.uId) {
                                return sentMessage(
                                    context,
                                    currentMessage.message,
                                    currentMessage.image);
                              } else {
                                return recivedMessage(
                                    context,
                                    currentMessage.message,
                                    currentMessage.image);
                              }
                            }),
                            itemCount: cubit.messages.length + 1),
                      ),
                      //Input Field
                      inputField(context, state),
                    ],
                  ),
                ),
        );
      }),
    );
  }

  Widget inputField(BuildContext context, HomeLayoutStates state) {
    var cubit = HomeCubit.get(context);
    return Column(
      children: [
        //Image container
        if (cubit.messageImage != null)
          Stack(
            alignment: Alignment.center,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      height: 150,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8))),
                      child: Image(
                          fit: BoxFit.cover,
                          image: FileImage(cubit.messageImage!))),
                  Container(
                    decoration: BoxDecoration(
                        color: mainColor.withOpacity(0.6),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8))),
                    height: 150,
                    width: double.infinity,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: defaultCloseButton(
                        onTap: () => cubit.cancelImage(ImageType.message),
                        radius: 12),
                  ),
                ],
              ),
              if (state is HomeUploadImageLoadingState)
                CircularProgressIndicator(
                  color: Colors.white,
                  value: state.percentage == null
                      ? null
                      : (state.percentage! / 100),
                ),
            ],
          ),
        Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: mainColor),
              borderRadius: cubit.messageImage == null
                  ? BorderRadius.circular(8)
                  : const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8))),
          child: Row(
            children: [
              Form(
                key: formKey,
                child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      maxLines: 2,
                      maxLength: 150,
                      decoration: InputDecoration(
                        counterText: "",
                        suffixIcon: IconButton(
                            onPressed: () {
                              cubit.selectImage(ImageType.message);
                            },
                            icon: const Icon(IconBroken.Image)),
                        border: InputBorder.none,
                        hintStyle: const TextStyle(
                            fontSize: 14, overflow: TextOverflow.ellipsis),
                        hintText: 'Message',
                      ),
                      controller: messageController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your message';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              //Send button
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: cubit.messageImage == null
                        ? const BorderRadiusDirectional.only(
                            topEnd: Radius.circular(7),
                            bottomEnd: Radius.circular(7))
                        : null),
                height: double.maxFinite,
                child: InkWell(
                    onTap: () async {
                      if (cubit.messageImage != null) {
                        await cubit.uploadImage(
                            directory: defaultMessageImageDirectory(
                                cubit.messageImage!.path),
                            imageType: ImageType.message);

                        await cubit.sendMessage(
                            reciverId: reciverModel.uId,
                            message: messageController.text.trim());
                        cubit.messageImage = null;
                        cubit.messageImageLink = null;
                      } else if (messageController.text.trim().isNotEmpty) {
                        cubit.sendMessage(
                            reciverId: reciverModel.uId,
                            message: messageController.text);
                      }
                    },
                    child: const Icon(
                      IconBroken.Send,
                      color: Colors.white,
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget sentMessage(BuildContext context, String message, String image) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 30, bottom: 10),
      child: Align(
        alignment: AlignmentDirectional.topEnd,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: mainColor.withOpacity(0.2),
              borderRadius: const BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(10),
                  topStart: Radius.circular(10),
                  topEnd: Radius.circular(10))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (image != '')
                InkWell(
                  onTap: () {
                    SchedulerBinding.instance?.addPostFrameCallback((_) {
                      navigatTo(
                          context: context,
                          screen: ImageViewerScreen(image: image),
                          replace: false);
                    });
                  },
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Hero(
                      tag: image,
                      child: CachedNetworkImage(
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                        imageUrl: image,
                      ),
                    ),
                  ),
                ),
              if (image != '' && message != '') const SizedBox(height: 10),
              if (message != '') Text(message),
            ],
          ),
        ),
      ),
    );
  }

  Widget recivedMessage(BuildContext context, String message, String image) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 30, bottom: 10),
      child: Align(
        alignment: AlignmentDirectional.topStart,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadiusDirectional.only(
                  bottomEnd: Radius.circular(10),
                  topStart: Radius.circular(10),
                  topEnd: Radius.circular(10))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (image != '')
                InkWell(
                  onTap: () {
                    navigatTo(
                        context: context,
                        screen: ImageViewerScreen(image: image),
                        replace: false);
                  },
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Hero(
                      tag: image,
                      child: CachedNetworkImage(
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                          imageUrl: image),
                    ),
                  ),
                ),
              if (image != '' && message != '') const SizedBox(height: 10),
              if (message != '')
                Text(
                  message,
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                  maxLines: 2,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void goTOEnd() async {
    if (scrollController.positions.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 300));
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        scrollController
            .animateTo(scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 400),
                curve: Curves.fastOutSlowIn)
            .catchError((e) {});
      });
    }
  }
}
