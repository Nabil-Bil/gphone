import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gphone/src/screens/cart_screen.dart';
import 'package:gphone/src/screens/home_screen.dart';
import 'package:gphone/src/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  final int index;
  const MainScreen({Key? key, this.index = 0}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<BottomNavigationBarItem> _navigationBarItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    const BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.bagShopping), label: 'Cart'),
    const BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.cartShopping), label: 'Orders'),
    // const BottomNavigationBarItem(
    //     icon: Icon(FontAwesomeIcons.wallet), label: 'Wallet'),
    const BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.solidUser), label: 'Profile'),
  ];

  final List<Widget> _widgetOptions = [
    const HomeScreen(),
    const CartScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];
  late int _currentIndex;
  @override
  void initState() {
    _currentIndex = widget.index;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: _navigationBarItems,
        currentIndex: _currentIndex,
        showUnselectedLabels: true,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
      body: _widgetOptions.elementAt(_currentIndex),
    );
  }
}
