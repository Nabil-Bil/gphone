import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gphone/src/helpers/auth_service.dart';
import 'package:gphone/src/helpers/firebase_service.dart';
import 'package:gphone/src/screens/auth_screen.dart';
import 'package:gphone/src/screens/edit_profile_screen.dart';
import 'package:gphone/src/screens/favorites_list_screen.dart';
import 'package:gphone/src/screens/help_center.dart';
import 'package:gphone/src/screens/onboarding_screen.dart';
import 'package:gphone/src/screens/phone_details_screen.dart';
import 'package:gphone/src/screens/privacy_policy_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: constant_identifier_names

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseService.initFirebase();

  final perfs = await SharedPreferences.getInstance();
  bool showHome = perfs.getBool('showHome') ?? false;

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
      title: "GPhone",
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.urbanistTextTheme().copyWith(
          titleLarge: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.urbanist().fontFamily),
        ),
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
        inputDecorationTheme: InputDecorationTheme(
          border: InputBorder.none,
          filled: true,
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(15)),
          contentPadding: const EdgeInsets.all(20),
          hintStyle:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
        ),
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.black, selectionColor: Colors.grey[400]),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        indicatorColor: Colors.black,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.black,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.black),
            overlayColor: MaterialStateProperty.resolveWith(
              (states) {
                return states.contains(MaterialState.pressed)
                    ? const Color.fromARGB(255, 238, 238, 238)
                    : null;
              },
            ),
          ),
        ),
        primaryIconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      home:
          !showHome ? const OnboardingScreen() : AuthService.handleAuthState(),
      routes: {
        AuthScreen.routeName: (context) => AuthScreen(),
        FavoriteListScreen.routeName: (context) => const FavoriteListScreen(),
        PhoneDetailScreen.routeName: (context) => const PhoneDetailScreen(),
        PrivacyPolicyScreen.routeName: (context) => const PrivacyPolicyScreen(),
        HelpCenterScreen.routeName: (context) => const HelpCenterScreen(),
        EditProfileScreen.routeName: (context) => const EditProfileScreen(),
      },
    );
  }
}
