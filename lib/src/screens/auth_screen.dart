import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gphone/src/widgets/custom_outlined_button.dart';
import 'package:gphone/src/widgets/custom_text_form_field.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth';
  bool isLogged;
  AuthScreen({Key? key, this.isLogged = false}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isHidden = true;
  late bool _isLogin;
  @override
  void initState() {
    _isLogin = widget.isLogged;
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isLogin ? 'Login to your Account' : 'Create your Account',
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(color: Colors.black),
                ),
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const CustomTextFormField(
                          hintText: 'Email', prefixIcon: Icons.email),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        hintText: 'Password',
                        prefixIcon: Icons.password,
                        suffixIcon:
                            _isHidden ? Icons.visibility_off : Icons.visibility,
                        obscureText: !_isHidden,
                        onPressedSuffixIcon: () {
                          setState(() {
                            _isHidden = !_isHidden;
                          });
                        },
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: null,
                        child: _isLogin
                            ? const Text('Sign in')
                            : const Text("Sign Up"),
                      ),
                      const SizedBox(height: 20),
                      _isLogin
                          ? GestureDetector(
                              onTap: () {},
                              child: Text(
                                'Forgot the password?',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            )
                          : Container(),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              height: 1,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            "or continue with",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: Colors.grey[700]),
                          ),
                          const SizedBox(width: 20),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomOutlinedButton(children: const [
                            Icon(
                              FontAwesomeIcons.facebook,
                              color: Colors.blue,
                              size: 30,
                            )
                          ], onPressed: () {}),
                          CustomOutlinedButton(children: [
                            SvgPicture.asset('assets/icons/google.svg',
                                width: 30),
                          ], onPressed: () {}),
                          CustomOutlinedButton(children: [
                            SvgPicture.asset('assets/icons/microsoft.svg',
                                width: 30),
                          ], onPressed: () {}),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isLogin
                                ? "Don't have an account?"
                                : "Already have an account?",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.grey),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(
                              _isLogin ? "Sign up" : "Sign in",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
