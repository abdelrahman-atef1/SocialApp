import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/modules/register/cubit/cubit.dart';
import 'package:social_app/modules/register/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/styles/colors.dart';

TextEditingController emailController = TextEditingController();
TextEditingController nameController = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) => RegisterCubit()),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
          listener: ((context, state) {
        if (state is RegisterSuccessState) {
          navigatTo(context: context, screen: const HomeLayout());
        }
      }), builder: (context, state) {
        var cubit = RegisterCubit.get(context);
        return Scaffold(
          //appBar: AppBar(),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('REGISTER',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(color: Colors.black)),
                          Text('Register now and connect with friends.',
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(
                            height: 20,
                          ),
                          defaultTextFormField(
                              keyboardType: TextInputType.name,
                              textController: nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Name can\'t be empty.';
                                }
                                return null;
                              },
                              labelText: 'Name',
                              prefixIcon: Icons.person),
                          const SizedBox(
                            height: 20,
                          ),
                          defaultTextFormField(
                              keyboardType: TextInputType.emailAddress,
                              textController: emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email Address can\'t be empty.';
                                }
                                return null;
                              },
                              labelText: 'Email',
                              prefixIcon: Icons.email),
                          const SizedBox(
                            height: 20,
                          ),
                          defaultTextFormField(
                              keyboardType: TextInputType.phone,
                              textController: phoneController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Phone number can\'t be empty.';
                                }
                                return null;
                              },
                              labelText: 'Phone',
                              prefixIcon: Icons.phone),
                          const SizedBox(
                            height: 20,
                          ),
                          defaultTextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            textController: passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password can\'t be empty.';
                              }
                              return null;
                            },
                            labelText: 'Password',
                            prefixIcon: Icons.lock,
                            isPassword: cubit.isPassword,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  cubit.changePasswordVisibility();
                                },
                                icon: cubit.isPassword
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility)),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          state is RegisterLoadingState
                              ? const Center(child: CircularProgressIndicator())
                              : SizedBox(
                                  width: double.infinity,
                                  child: MaterialButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        cubit
                                            .register(
                                                context: context,
                                                name: nameController.text,
                                                email: emailController.text,
                                                phone: phoneController.text,
                                                password:
                                                    passwordController.text)
                                            .catchError((e) {
                                          showToast(networkErrorMessage,
                                              ToastState.error);
                                          print(e.toString());
                                        });
                                        if (state is RegisterSuccessState) {
                                          navigatTo(
                                              context: context,
                                              screen: const HomeLayout());
                                        }
                                      }
                                    },
                                    color: mainColor,
                                    textColor: Colors.white,
                                    child: const Text('Register'),
                                  ),
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Already have an account?'),
                              TextButton(
                                  onPressed: () {
                                    navigatTo(
                                        context: context,
                                        screen: LoginScreen());
                                  },
                                  child: const Text('Login'))
                            ],
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
