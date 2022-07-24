import 'package:flutter/material.dart';
import 'package:gphone/src/widgets/phone_list_item.dart';

import '../models/phone.dart';

class PhoneList extends StatelessWidget {
  final List<Phone> data;
  const PhoneList({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 25,
          mainAxisSpacing: 25,
          mainAxisExtent: 250),
      itemBuilder: (context, index) {
        return PhoneListItem(
          id: data[index].id,
          name: data[index].name,
          imageUrl: data[index].imageUrl,
          price: data[index].price,
          rate: data[index].rate,
        );
      },
    );
  }
}
