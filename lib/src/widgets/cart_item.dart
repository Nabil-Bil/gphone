import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gphone/src/helpers/phone_service.dart';

import '../models/cart.dart';

class CartItem extends StatefulWidget {
  final Cart cartItem;
  const CartItem({Key? key, required this.cartItem}) : super(key: key);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("phones")
              .doc(widget.cartItem.id)
              .snapshots(),
          builder: (context, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return Container();
            }
            if (snapshots.data == null) {
              return Container();
            }
            final phone = snapshots.data!.data()!;
            return Container(
              height: 175,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    width: 125,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15)),
                    child: Image.network(
                      phone['imageUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 9,
                                  child: Text(
                                    phone['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                "Remove From Cart ?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("No")),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);

                                                  PhoneService.removeFromCart(
                                                      widget.cartItem.id);
                                                },
                                                child: const Text("Yes"),
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child:
                                        const Icon(FontAwesomeIcons.trashCan),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "\$${widget.cartItem.price.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  width: 100,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9999),
                                      color: Colors.grey[200]),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              if (widget.cartItem.quantity >
                                                  1) {
                                                int newQuantity =
                                                    widget.cartItem.quantity -
                                                        1;
                                                Cart newCart = Cart(
                                                    id: widget.cartItem.id,
                                                    quantity: newQuantity,
                                                    price: (newQuantity *
                                                            phone['description']
                                                                ['price'])
                                                        .toDouble());
                                                PhoneService.addToCart(newCart);
                                              }
                                            },
                                            child: const Icon(
                                              Icons.remove,
                                              size: 15,
                                            )),
                                        Text(
                                          widget.cartItem.quantity.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w900),
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              int newQuantity =
                                                  widget.cartItem.quantity + 1;
                                              Cart newCart = Cart(
                                                  id: widget.cartItem.id,
                                                  quantity: newQuantity,
                                                  price: (newQuantity *
                                                          phone['description']
                                                              ['price'])
                                                      .toDouble());
                                              PhoneService.addToCart(newCart);
                                            },
                                            child: const Icon(
                                              Icons.add,
                                              size: 15,
                                            )),
                                      ]),
                                )
                              ],
                            )
                          ]),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
