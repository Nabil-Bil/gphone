import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({Key? key}) : super(key: key);

  Future<void> _launchUrl(
      {required String uri,
      LaunchMode mode = LaunchMode.platformDefault}) async {
    if (!await launchUrl(Uri.parse(uri), mode: mode)) {}
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SocialMedia(
          icon: FontAwesomeIcons.whatsapp,
          title: "WhatsApp",
          onTap: () {
            _launchUrl(
                uri: "whatsapp://send?phone=72611942",
                mode: LaunchMode.externalNonBrowserApplication);
          },
        ),
        SocialMedia(
          icon: FontAwesomeIcons.globe,
          title: "Website",
          onTap: () {
            _launchUrl(
              uri: "https://flutter.dev/",
            );
          },
        ),
        SocialMedia(
          icon: FontAwesomeIcons.facebook,
          title: "Facebook",
          onTap: () {
            _launchUrl(uri: "https://www.facebook.com/");
          },
        ),
        SocialMedia(
          icon: FontAwesomeIcons.twitter,
          title: "Twitter",
          onTap: () {
            _launchUrl(uri: "https://twitter.com/");
          },
        ),
        SocialMedia(
          icon: FontAwesomeIcons.instagram,
          title: "Instagram",
          onTap: () {
            _launchUrl(uri: "https://www.instagram.com/");
          },
        ),
      ],
    );
  }
}

class SocialMedia extends StatelessWidget {
  final IconData icon;
  final String title;
  final void Function()? onTap;
  const SocialMedia(
      {Key? key, required this.icon, this.onTap, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      surfaceTintColor: Colors.white,
      margin: const EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: onTap,
          child: ListTile(
            leading: Icon(
              icon,
              color: Colors.black,
            ),
            title: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
