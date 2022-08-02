import 'package:flutter/material.dart';
import 'package:gphone/src/widgets/contact_us.dart';

class HelpCenterScreen extends StatefulWidget {
  static const String routeName = "/help-center";
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Help Center"),
          bottom: const TabBar(
            unselectedLabelColor: Colors.grey,
            indicatorPadding: EdgeInsets.symmetric(horizontal: 25),
            indicatorWeight: 4,
            labelColor: Colors.black,
            tabs: [
              Tab(text: "FAQ"),
              Tab(text: "Contact us"),
            ],
          ),
        ),
        body: const TabBarView(children: [Center(), ContactUs()]),
      ),
    );
  }
}
