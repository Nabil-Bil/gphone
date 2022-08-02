import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/cart.dart';

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

  static Future<void> addToCart(Cart cartItem) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("cart")
        .doc(cartItem.id)
        .set({"price": cartItem.price, "quantity": cartItem.quantity,"name":cartItem.name});
  }

  static Future<void> removeFromCart(String id) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("cart")
        .doc(id)
        .delete();
  }
}
