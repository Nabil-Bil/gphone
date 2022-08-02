import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String? id;
  final double amount;
  final List<String> products;

  final Timestamp dateTime;
  Order({
    this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}
