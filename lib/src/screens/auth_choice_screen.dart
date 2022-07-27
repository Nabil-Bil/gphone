import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gphone/src/helpers/auth_service.dart';
import 'package:gphone/src/screens/auth_screen.dart';
import 'package:gphone/src/widgets/custom_outlined_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  SvgPicture.asset('assets/illustrations/authentication.svg',
                      width: MediaQuery.of(context).size.width * 0.35),
                  const SizedBox(height: 20),
                  Text(
                    "Let's you in",
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 20),
                  CustomOutlinedButton(
                      width: double.maxFinite,
                      children: [
                        const Icon(FontAwesomeIcons.facebook,
                            color: Colors.blue, size: 25),
                        const SizedBox(width: 10),
                        Text(
                          "Continue with Facebook",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                      onPressed: () async {
                        await AuthService.signInWithFacebook();
                      }),
                  const SizedBox(height: 15),
                  CustomOutlinedButton(
                      width: double.maxFinite,
                      children: [
                        // const Icon(FontAwesomeIcons.google, color: Colors.red),
                        SvgPicture.asset('assets/icons/google.svg', width: 25),
                        const SizedBox(width: 10),
                        Text(
                          "Continue with Google",
                          style: Theme.of(context).textTheme.titleMedium,
                        )
                      ],
                      onPressed: () async {
                        await AuthService.signInWithGoogle();
                      }),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          height: 1,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        "or",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 20),
                      const Expanded(child: Divider())
                    ],
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return AuthScreen(
                            isLogged: true,
                          );
                        }),
                      );
                    },
                    child: const Text(
                      "Sign in with password",
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.grey),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return AuthScreen();
                            }),
                          );
                        },
                        child: Text(
                          "Sign up",
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
            ),
          ),
        ),
      ),
    );
  }
}
