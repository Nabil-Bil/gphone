import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneService {
  static Future<void> addToFavorite(String id) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("favorites")
        .doc(id)
        .set({});
  }

  static Future<void> removeFromFavorite(String id) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("favorites")
        .doc(id)
        .delete();
  }
}
