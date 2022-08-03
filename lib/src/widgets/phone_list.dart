import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gphone/src/widgets/phone_list_item.dart';

import '../models/phone.dart';

class PhoneList extends StatefulWidget {
  final List<String> data;
  final bool allData;
  const PhoneList({Key? key, required this.data, this.allData = false})
      : super(key: key);

  @override
  State<PhoneList> createState() => _PhoneListState();
}

class _PhoneListState extends State<PhoneList> {
  final List<Phone> phoneList = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: widget.allData
            ? FirebaseFirestore.instance.collection("phones").snapshots()
            : FirebaseFirestore.instance
                .collection('phones')
                .limit(10)
                .where(FieldPath.documentId,
                    whereIn: widget.data.sublist(
                      0,
                      widget.data.length > 10
                          ? widget.data.length - (widget.data.length - 10)
                          : widget.data.length,
                    ))
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          }
          if (snapshot.data != null) {
            for (QueryDocumentSnapshot<Map<String, dynamic>> phoneData
                in snapshot.data!.docs) {
              phoneList.add(Phone(
                id: phoneData.id,
                name: phoneData['name'],
                imageUrl: phoneData['imageUrl'],
                rate: double.parse(phoneData['description']['rate'].toString()),
                price:
                    double.parse(phoneData['description']['price'].toString()),
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
              ));
            }
          }

          return GridView.builder(
            shrinkWrap: true,
            itemCount: widget.allData
                ? snapshot.requireData.docs.length
                : widget.data.length > 10
                    ? widget.data.length - (widget.data.length - 10)
                    : widget.data.length,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 25,
                mainAxisSpacing: 25,
                mainAxisExtent: 250),
            itemBuilder: (context, index) {
              return PhoneListItem(
                id: phoneList[index].id,
                name: phoneList[index].name,
                imageUrl: phoneList[index].imageUrl,
                price: phoneList[index].price,
                rate: phoneList[index].rate,
              );
            },
          );
        });
  }
}
