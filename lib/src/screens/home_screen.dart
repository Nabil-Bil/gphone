import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gphone/src/helpers/auth.dart';
import 'package:gphone/src/widgets/custom_text_form_field.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/phone.dart';
import '../widgets/phone_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Phone> phoneData = [];
  @override
  void initState() {
    getJson().then((value) {
      var data = jsonDecode(value) as List<dynamic>;
      List<Phone> phones = [];
      int i = 0;
      for (var phone in data) {
        phones.add(Phone(
          id: i.toString(),
          name: phone['name']!,
          imageUrl: phone['imageUrl']!,
          price: 100 + Random().nextDouble() * 300,
          rate: Random().nextDouble() * 5,
        ));
        i++;
      }
      setState(() {
        phoneData = phones;
      });
    });

    super.initState();
  }

  Future<String> getJson() {
    return rootBundle.loadString('data/data.json');
  }

  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          leading: FittedBox(
              child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(9999),
                child: Image.network(
                  FirebaseAuth.instance.currentUser!.photoURL ?? '',
                  errorBuilder: ((context, error, stackTrace) {
                    return const CircleAvatar(
                      child: Text('U'),
                    );
                  }),
                ),
              ),
            ],
          )),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good Morning 👋",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.grey),
              ),
              Text(
                FirebaseAuth.instance.currentUser!.displayName ?? 'Unknown',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(FontAwesomeIcons.bell),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(FontAwesomeIcons.heart),
            ),
            IconButton(
              onPressed: () {
                AuthService.signOut();
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
              child: Column(children: [
                CustomTextFormField(
                  prefixIcon: FontAwesomeIcons.magnifyingGlass,
                  suffixIcon: const IconButton(
                      icon: Icon(
                        FontAwesomeIcons.sliders,
                        color: Colors.black,
                      ),
                      onPressed: null),
                  controller: _controller,
                ),
                phoneData.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : PhoneList(
                        data: phoneData,
                      )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
