import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gphone/src/widgets/phone_list.dart';

import '../widgets/no_data.dart';

class FavoriteListScreen extends StatelessWidget {
  static const String routeName = '/favoritesList';
  const FavoriteListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wishlist"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('favorites')
              .snapshots(),
          builder: (context, querySnapshot) {
            if (querySnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            List<String> phonesId = [];
            if (querySnapshot.data != null) {
              for (var phone in querySnapshot.data!.docs) {
                phonesId.add(phone.id);
              }
            }
            if (phonesId.isEmpty) {
              return const NoData(
                illustrationPath: 'assets/illustrations/noData.svg',
                text: "WishList Empty",
              );
            }
            return SingleChildScrollView(
              child: PhoneList(
                key: UniqueKey(),
                data: phonesId,
              ),
            );
          }),
    );
  }
}
