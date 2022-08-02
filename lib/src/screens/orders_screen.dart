import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:gphone/src/widgets/no_data.dart';
import 'package:gphone/src/widgets/order_item_tile.dart';

class OrderSscreen extends StatelessWidget {
  const OrderSscreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("My Orders")),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var data = snapshot.requireData.docs;
            return data.isEmpty
                ? const NoData(
                    illustrationPath: "assets/illustrations/noData.svg",
                    text: "You don't have an order yet",
                  )
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) => OrderItemTile(
                      products: data[index].data()['products'],
                      id: data[index].id,
                      price: data[index].data()['amount'],
                      date: data[index].data()['dateTime'],
                    ),
                  );
          },
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("orders")
              .snapshots(),
        ));
  }
}
