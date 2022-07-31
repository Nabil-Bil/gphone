import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gphone/src/widgets/cart_item.dart';
import 'package:gphone/src/widgets/no_data.dart';

import '../models/cart.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = "cart";

  const CartScreen({Key? key}) : super(key: key);
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Cart",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("cart")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return const Center(
              child: NoData(
                illustrationPath: "assets/illustrations/noData.svg",
                text: "No Phone Added to Cart",
              ),
            );
          }
          double totalPrice = 0;
          for (var phone in snapshot.data!.docs) {
            totalPrice += phone.data()['price'];
          }
          return snapshot.data!.docs.isEmpty
              ? const Center(
                  child: NoData(
                    illustrationPath: "assets/illustrations/noData.svg",
                    text: "No Phone Added to Cart",
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        key: const PageStorageKey('page'),
                        padding: const EdgeInsets.all(15),
                        itemBuilder: (context, index) {
                          return CartItem(
                            key: ValueKey(snapshot.data!.docs[index].id),
                            cartItem: Cart(
                              id: snapshot.data!.docs[index].id,
                              price: snapshot.data!.docs[index]['price'],
                              quantity: snapshot.data!.docs[index]['quantity'],
                            ),
                          );
                        },
                        itemCount: snapshot.data!.docs.length,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Row(children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total price",
                                style: Theme.of(context).textTheme.caption,
                              ),
                              Text(
                                "\$$totalPrice",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Text(
                              "Continue to Payment",
                              style: TextStyle(fontSize: 14),
                            ),
                            label: const Icon(
                              FontAwesomeIcons.arrowRight,
                              size: 15,
                            ),
                          ),
                        )
                      ]),
                    )
                  ],
                );
        },
      ),
    );
  }
}
