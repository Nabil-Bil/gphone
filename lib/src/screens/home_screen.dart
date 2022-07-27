import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gphone/src/widgets/custom_text_form_field.dart';

import '../models/phone.dart';
import '../widgets/phone_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Phone> _phoneDataList = [];
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
                const SizedBox(width: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(9999),
                  child: FirebaseAuth.instance.currentUser!.photoURL == null
                      ? CircleAvatar(
                          child: Text(
                              FirebaseAuth.instance.currentUser!.displayName ??
                                  'U'),
                        )
                      : Image.network(
                          FirebaseAuth.instance.currentUser!.photoURL ?? '',
                        ),
                ),
              ],
            ),
          ),
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
          ],
        ),
        body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance.collection('/phones').get(),
            builder: (BuildContext context, snaphot) {
              if (snaphot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final data = snaphot.data!.docs;
              for (var phone in data) {
                final phoneData = phone.data();
                _phoneDataList.add(Phone(
                  id: phone.id,
                  name: phoneData['name'],
                  imageUrl: phoneData['imageUrl'],
                  rate:
                      double.parse(phoneData['description']['rate'].toString()),
                  price: double.parse(
                      phoneData['description']['price'].toString()),
                ));
              }
              return _phoneDataList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/illustrations/noData.svg",
                            height: MediaQuery.of(context).size.height / 3,
                          ),
                          const SizedBox(height: 25),
                          Text("No Phone Found",
                              style: Theme.of(context).textTheme.displaySmall),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () {
                        setState(() {});
                        return Future.delayed(Duration.zero);
                      },
                      child: SingleChildScrollView(
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
                              PhoneList(
                                data: _phoneDataList,
                              )
                            ]),
                          ),
                        ),
                      ),
                    );
            }),
      ),
    );
  }
}
