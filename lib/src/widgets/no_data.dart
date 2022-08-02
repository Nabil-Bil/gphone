import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoData extends StatelessWidget {
  final String illustrationPath;
  final String? text;
  const NoData({Key? key, required this.illustrationPath, this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            illustrationPath,
            height: MediaQuery.of(context).size.height / 3,
          ),
          const SizedBox(height: 25),
          text == null
              ? Container()
              : Text(text!,
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
