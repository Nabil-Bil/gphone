import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_validation/form_validation.dart';
import 'package:gphone/src/helpers/auth.dart';
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
  bool _isActive = false;
  final Map<String, String> _userData = {
    "email": '',
    "password": '',
  };

  final emailConroller = TextEditingController();
  final passwordConroller = TextEditingController();
  @override
  void initState() {
    _isLogin = widget.isLogged;
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  Future<void> authenticate() async {
    final bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      try {
        if (_isLogin) {
          await AuthService.signInWithCredential(
              _userData['email']!, _userData['password']!);
        } else {
          await AuthService.signUpWithCredential(
              _userData['email']!, _userData['password']!);
        }
        if (!mounted) {
          return;
        }
        Navigator.pop(context);
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child: SingleChildScrollView(
              physics: const PageScrollPhysics(),
              child: Column(
                children: [
                  Text(
                    _isLogin ? 'Login to your Account' : 'Create your Account',
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            Validator validator = Validator(validators: [
                              RequiredValidator(),
                              EmailValidator(),
                            ]);

                            return validator.validate(
                                context: context, label: 'Email', value: value);
                          },
                          hintText: 'Email',
                          prefixIcon: Icons.email,
                          onChanged: (value) {
                            _userData['email'] = value.trim();
                            setState(() {
                              if (_userData['password'] == '' ||
                                  _userData['email'] == '') {
                                _isActive = false;
                              } else {
                                _isActive = true;
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        CustomTextFormField(
                          validator: (value) {
                            Validator validator = Validator(validators: [
                              RequiredValidator(),
                              MinLengthValidator(length: 5)
                            ]);

                            return validator.validate(
                                context: context,
                                label: 'Password',
                                value: value);
                          },
                          hintText: 'Password',
                          prefixIcon: Icons.lock,
                          suffixIcon: !_isHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                          obscureText: _isHidden,
                          onPressedSuffixIcon: () {
                            setState(() {
                              _isHidden = !_isHidden;
                            });
                          },
                          onChanged: (value) {
                            _userData['password'] = value.trim();
                            setState(() {
                              if (_userData['password'] == '' ||
                                  _userData['email'] == '') {
                                _isActive = false;
                              } else {
                                _isActive = true;
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: _isActive ? authenticate : null,
                          child: _isLogin
                              ? const Text('Sign in')
                              : const Text("Sign Up"),
                        ),
                        const SizedBox(height: 15),
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
                        const SizedBox(height: 20),
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
                            CustomOutlinedButton(
                                children: const [
                                  Icon(
                                    FontAwesomeIcons.facebook,
                                    color: Colors.blue,
                                    size: 30,
                                  )
                                ],
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await AuthService.signInWithFacebook();
                                }),
                            CustomOutlinedButton(
                                children: [
                                  SvgPicture.asset('assets/icons/google.svg',
                                      width: 30),
                                ],
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await AuthService.signInWithGoogle();
                                }),
                          ],
                        ),
                        const SizedBox(height: 20),
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
                                  _formKey.currentState!.reset();
                                  _formKey.currentState!.activate();

                                  _isLogin = !_isLogin;
                                  emailConroller.text = '';
                                  passwordConroller.text = '';
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
      ),
    );
  }
}
