import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gphone/src/helpers/phone_service.dart';

class PhoneListItem extends StatelessWidget {
  final String id;
  final String name;
  final String imageUrl;
  final double rate;
  final double price;

  const PhoneListItem({
    Key? key,
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rate,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('favorites')
            .doc(id)
            .snapshots(),
        builder: (context, snapshot) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Stack(alignment: const Alignment(0.9, -0.9), children: [
                Container(
                  width: 175,
                  height: 175,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(210, 210, 210, 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(15),
                  child: FadeInImage(
                    fit: BoxFit.contain,
                    placeholder:
                        const AssetImage('assets/images/phone_placeholder.png'),
                    image: NetworkImage(imageUrl),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/phone_placeholder.png');
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    PhoneService.addToFavorite(id);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Icon(
                      snapshot.data != null
                          ? FontAwesomeIcons.solidHeart
                          : FontAwesomeIcons.heart,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 5),
              Text(
                name,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(FontAwesomeIcons.star),
                  const SizedBox(width: 10),
                  Text(rate.toStringAsFixed(2),
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold)),
                  Container(
                    width: 1,
                    height: 15,
                    color: Colors.black,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  Container(
                    child: Text(
                      "\$${price.toStringAsFixed(2)}",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          );
        });
  }
}
