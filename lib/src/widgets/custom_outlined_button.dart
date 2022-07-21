import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  final List<Widget> children;
  final double? width;
  final double? height;
  final Function() onPressed;
  const CustomOutlinedButton(
      {Key? key,
      required this.children,
      this.width,
      this.height,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          decoration: BoxDecoration(
            border: Border.all(
                color: const Color.fromARGB(255, 223, 223, 223),
                width: 1,
                style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          )),
    );
  }
}
