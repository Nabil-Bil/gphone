import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import "package:expandable/expandable.dart";
import 'package:intl/intl.dart';

class OrderItemTile extends StatefulWidget {
  final String id;
  final double price;
  final Timestamp date;
  final List products;
  const OrderItemTile(
      {Key? key,
      required this.price,
      required this.date,
      required this.products,
      required this.id})
      : super(key: key);

  @override
  State<OrderItemTile> createState() => _OrderItemTileState();
}

class _OrderItemTileState extends State<OrderItemTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: ExpandablePanel(
            header:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "\$${widget.price.toStringAsFixed(2)}",
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              Text(
                DateFormat("dd/MM/yyyy H:m").format(widget.date.toDate()),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ]),
            collapsed: Container(),
            expanded: Column(
              children: [
                ...widget.products
                    .map((product) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product['name'],
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "${product['quantity']} X \$${product['price']}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                            )
                          ],
                        ))
                    .toList()
              ],
            )),
      ),
    );
  }
}
