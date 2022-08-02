import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';

class FirebaseService {

  static Future _connectToFirebaseEmulator() async {
    final localHostString = Platform.isAndroid ? '10.0.2.2' : 'localhost';
    FirebaseFirestore.instance.settings = Settings(
        host: "$localHostString:8080",
        sslEnabled: false,
        persistenceEnabled: true);

    FirebaseAuth.instance.useAuthEmulator(localHostString, 9099);
  }

  static Future<void> initFirebase({bool useEmulator=false}) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
    if (useEmulator) _connectToFirebaseEmulator();
  }
}
