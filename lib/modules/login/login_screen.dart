import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/modules/login/cubit/cubit.dart';
import 'package:social_app/modules/login/cubit/states.dart';
import 'package:social_app/modules/register/register_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/colors.dart';

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) => LoginCubit()),
      child: BlocConsumer<LoginCubit, LoginStates>(listener: ((context, state) {
        if (state is LoginSuccessState) {
          navigatTo(context: context, screen: const HomeLayout());
        }
      }), builder: (context, state) {
        var cubit = LoginCubit.get(context);
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('LOGIN',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(color: Colors.black)),
                          Text('Log in now and connect with friends.',
                              style: Theme.of(context).textTheme.bodyMedium),
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
                          SizedBox(
                            width: double.infinity,
                            child: state is LoginLoadingState
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : MaterialButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        cubit.login(
                                            context: context,
                                            email: emailController.text.trim(),
                                            password: passwordController.text);
                                      }
                                    },
                                    color: mainColor,
                                    textColor: Colors.white,
                                    child: const Text('Login'),
                                  ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Don\'t have an account?'),
                              TextButton(
                                  onPressed: () {
                                    navigatTo(
                                        context: context,
                                        screen: RegisterScreen());
                                  },
                                  child: const Text('Register'))
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
