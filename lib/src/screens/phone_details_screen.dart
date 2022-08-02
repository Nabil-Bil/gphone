import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gphone/src/helpers/phone_service.dart';
import 'package:gphone/src/models/cart.dart';
import 'package:gphone/src/screens/main_screen.dart';

import '../models/phone.dart';

class PhoneDetailScreen extends StatefulWidget {
  static const String routeName = "/phone-detail";
  const PhoneDetailScreen({Key? key}) : super(key: key);

  @override
  State<PhoneDetailScreen> createState() => _PhoneDetailScreenState();
}

class _PhoneDetailScreenState extends State<PhoneDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("phones")
              .doc(arguments['id'])
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final phoneData = snapshot.data!.data()!;

            final phone = Phone(
              id: arguments['id']!,
              name: phoneData['name'],
              imageUrl: phoneData['imageUrl'],
              rate: double.parse(phoneData['description']['rate'].toString()),
              price: double.parse(phoneData['description']['price'].toString()),
              battery: phoneData['description']['battery'],
              build: phoneData['description']['body']['build'],
              dimensions: phoneData['description']['body']['dimensions'],
              resolution: phoneData['description']['body']['resolution'],
              weight: phoneData['description']['body']['weight'],
              ram: phoneData['description']['memory']['ram'],
              storage: phoneData['description']['memory']['storage'],
              cpu: phoneData['description']['platform']['cpu'],
              gpu: phoneData['description']['platform']['gpu'],
              os: phoneData['description']['platform']['os'],
            );
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.height * 0.4,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Hero(
                      tag: arguments['id']!,
                      child: Image.network(
                        phone.imageUrl,
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: double.infinity,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                phone.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              StreamBuilder<
                                      DocumentSnapshot<Map<String, dynamic>>>(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .collection("favorites")
                                      .doc(arguments['id'])
                                      .snapshots(),
                                  builder: (context, snapshotFavorite) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Icon(FontAwesomeIcons.heart);
                                    }
                                    if (snapshotFavorite.data != null) {
                                      return GestureDetector(
                                          onTap: () {
                                            if (snapshotFavorite.data!.data() ==
                                                null) {
                                              PhoneService.addToFavorite(
                                                  arguments['id']!);
                                            } else {
                                              PhoneService.removeFromFavorite(
                                                  arguments['id']!);
                                            }
                                          },
                                          child: Icon(snapshotFavorite.data!
                                                      .data() ==
                                                  null
                                              ? FontAwesomeIcons.heart
                                              : FontAwesomeIcons.solidHeart));
                                    }
                                    return const Icon(FontAwesomeIcons.heart);
                                  }),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(FontAwesomeIcons.starHalfStroke),
                              const SizedBox(width: 10),
                              Text(phone.rate.toString())
                            ],
                          ),
                          const Divider(thickness: 1),
                          Text(
                            "Description",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontWeight: FontWeight.w900),
                          ),
                          DescriptionItem(
                              title: "Battery",
                              description: "${phone.battery} mA"),
                          DescriptionItem(
                              title: "Build", description: phone.build),
                          DescriptionItem(
                              title: "Battery",
                              description: "${phone.battery} mA"),
                          DescriptionItem(
                              title: "Dimensions",
                              description: phone.dimensions),
                          DescriptionItem(
                              title: "Resolution",
                              description: "${phone.battery} mA"),
                          DescriptionItem(
                              title: "Ram", description: "${phone.ram} GB"),
                          DescriptionItem(
                              title: "Storage",
                              description: "${phone.storage} GB"),
                          DescriptionItem(title: "CPU", description: phone.cpu),
                          DescriptionItem(title: "GPU", description: phone.gpu),
                          DescriptionItem(title: "OS", description: phone.os),
                          const Divider(thickness: 1),
                          AddToCart(
                            price: phone.price,
                            id: phone.id,
                            name: phone.name,
                          )
                        ],
                      ),
                    ),
                  ]),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class DescriptionItem extends StatelessWidget {
  final String title;
  final String description;
  const DescriptionItem(
      {Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title : ",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              description,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          )
        ],
      ),
    );
  }
}

class AddToCart extends StatefulWidget {
  final double price;
  final String id;
  final String name;

  const AddToCart(
      {Key? key, required this.price, required this.id, required this.name})
      : super(key: key);

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  late double totalPrice;
  int quantity = 1;
  @override
  void initState() {
    totalPrice = widget.price;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            children: [
              Text(
                "Quantity",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(width: 20),
              Container(
                width: 120,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9999),
                    color: Colors.grey[200]),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                          onTap: () {
                            if (quantity > 1) {
                              setState(() {
                                quantity--;
                                totalPrice = quantity * widget.price;
                              });
                            }
                          },
                          child: const Icon(Icons.remove)),
                      Text(
                        quantity.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.w900),
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              quantity++;
                              totalPrice = quantity * widget.price;
                            });
                          },
                          child: const Icon(Icons.add)),
                    ]),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total price",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\$$totalPrice",
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await PhoneService.addToCart(
                      Cart(
                          id: widget.id,
                          price: totalPrice,
                          quantity: quantity,
                          name: widget.name),
                    );
                    if (!mounted) return;
                    Navigator.pop(context);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: ((context) {
                          return const MainScreen(
                            index: 1,
                          );
                        }),
                      ),
                    );
                  },
                  icon: const Icon(FontAwesomeIcons.bagShopping),
                  label: const Text(
                    "Add to Cart",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
