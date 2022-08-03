import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_validation/form_validation.dart';
import 'package:gphone/src/helpers/auth_service.dart';
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
  bool _isActive = false;
  late bool _isLogin;
  bool _isLoading = false;

  final TextEditingController emailConroller = TextEditingController();
  final TextEditingController passwordConroller = TextEditingController();

  final Map<String, String> _userData = {
    "email": '',
    "password": '',
  };

  void activateButton() {
    setState(() {
      if (emailConroller.text == '' || passwordConroller.text == '') {
        _isActive = false;
      } else {
        _isActive = true;
      }
    });
  }

  @override
  void initState() {
    _isLogin = widget.isLogged;

    emailConroller.addListener(() {
      _userData['email'] = emailConroller.text.trim();
      activateButton();
    });

    passwordConroller.addListener(() {
      _userData['password'] = emailConroller.text.trim();

      activateButton();
    });
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  Future<void> authenticate() async {
    setState(() {
      _isLoading = true;
    });
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
      } on FirebaseAuthException catch (e) {
        String messsage = e.message?.toUpperCase() ?? "Something is wrong";
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
              label: 'Hide',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              }),
          content: Text(messsage),
          backgroundColor: Colors.black,
        ));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailConroller.dispose();
    passwordConroller.dispose();
    super.dispose();
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
                          controller: emailConroller,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email,
                          hintText: 'Email',
                          onChanged: (value) {
                            _userData['email'] = value.trim();
                          },
                          validator: (value) {
                            Validator validator = Validator(validators: [
                              RequiredValidator(),
                              EmailValidator(),
                            ]);

                            return validator.validate(
                                context: context, label: 'Email', value: value);
                          },
                        ),
                        const SizedBox(height: 15),
                        CustomTextFormField(
                          onChanged: (value) {
                            _userData['password'] = value.trim();
                          },
                          controller: passwordConroller,
                          keyboardType: TextInputType.text,
                          prefixIcon: Icons.lock,
                          hintText: 'Password',
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
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isHidden
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: passwordConroller.text.trim() != ''
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                            onPressed: passwordConroller.text.trim() != ''
                                ? () {
                                    setState(() {
                                      _isHidden = !_isHidden;
                                    });
                                  }
                                : null,
                          ),
                          obscureText: _isHidden,
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: _isActive
                              ? (_isLoading ? null : authenticate)
                              : null,
                          child: Builder(builder: (context) {
                            Widget widget = _isLogin
                                ? const Text('Sign in')
                                : const Text("Sign Up");
                            if (_isLoading) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  widget,
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              );
                            }
                            return widget;
                          }),
                        ),
                        const SizedBox(height: 15),
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
