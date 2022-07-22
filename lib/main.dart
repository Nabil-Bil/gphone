import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gphone/src/helpers/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gphone/src/screens/auth_screen.dart';
import 'package:gphone/src/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  final perfs = await SharedPreferences.getInstance();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  bool showHome = perfs.getBool('showHome') ?? false;

  runApp(MyApp(
    showHome: showHome,
  ));
}

class MyApp extends StatelessWidget {
  final bool showHome;
  const MyApp({Key? key, required this.showHome}) : super(key: key);
  Color getBackgroundColor(states) {
    if (states.contains(MaterialState.disabled)) {
      return const Color.fromRGBO(57, 57, 57, 1);
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.urbanistTextTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(6),
            foregroundColor: MaterialStateProperty.all(Colors.white),
            overlayColor: MaterialStateProperty.resolveWith(
              (states) {
                return states.contains(MaterialState.pressed)
                    ? const Color.fromRGBO(57, 57, 57, 1)
                    : null;
              },
            ),
            backgroundColor:
                MaterialStateProperty.resolveWith(getBackgroundColor),
            splashFactory: InkRipple.splashFactory,
            textStyle: MaterialStateProperty.resolveWith((states) {
              return Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(fontWeight: FontWeight.w400);
            }),
            minimumSize:
                MaterialStateProperty.all(const Size(double.infinity, 65)),
          ),
        ),
      ),
      home:
          !showHome ? const OnboardingScreen() : AuthService.handleAuthState(),
      routes: {
        AuthScreen.routeName: (context) => AuthScreen(),
      },
    );
  }
}
