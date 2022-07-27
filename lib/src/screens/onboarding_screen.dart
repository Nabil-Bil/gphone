import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gphone/src/helpers/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _index = 0;
  final List<Map<String, String>> _listPages = [
    {
      'image': 'assets/illustrations/onboarding1.svg',
      'title': 'We provide high quality products just for you'
    },
    {
      'image': 'assets/illustrations/onboarding2.svg',
      'title': 'Your satisfaction is our number one priority'
    },
    {
      'image': 'assets/illustrations/onboarding3.svg',
      'title': "Let's fulfill your daily needs with Gphone right now!"
    },
  ];
  @override
  void initState() {
    _pageController = PageController(initialPage: _index);
    _pageController.addListener(() {
      setState(() {
        _index = _pageController.page!.toInt();
      });
    });
    super.initState();
  }

  Future<void> showOnboardingScreenOneTime() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('showHome', true);
    // ignore: use_build_context_synchronously
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => AuthService.handleAuthState(),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return OnBoardContent(
                      image: _listPages[index]['image']!,
                      title: _listPages[index]['title']!);
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                ...List.generate(
                    3,
                    (index) => DotIndicator(
                          isActive: index == _index,
                        ))
              ]),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
                onPressed: () {
                  _index != 2
                      ? _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease)
                      : showOnboardingScreenOneTime();
                },
                child: Text(_index != 2 ? 'Next' : 'Get started'))
          ],
        ),
      )),
    );
  }
}

class DotIndicator extends StatelessWidget {
  final bool isActive;
  const DotIndicator({Key? key, this.isActive = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: isActive ? 30 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey[400],
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class OnBoardContent extends StatelessWidget {
  final String image;
  final String title;
  const OnBoardContent({
    Key? key,
    required this.image,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          image,
          height: MediaQuery.of(context).size.width / 2,
        ),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
