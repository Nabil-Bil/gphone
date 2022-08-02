import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gphone/src/helpers/auth_service.dart';
import 'package:gphone/src/screens/help_center.dart';
import 'package:gphone/src/screens/privacy_policy_screen.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late bool toggleDarkMode = false;
  Future<void> updateProfilePicture() async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    if (pickedImage == null) {
      return;
    }
    CroppedFile? croppedImage = await ImageCropper.platform
        .cropImage(sourcePath: pickedImage.path, aspectRatioPresets: [
      CropAspectRatioPreset.square
    ], uiSettings: [
      AndroidUiSettings(
        backgroundColor: Colors.black,
        toolbarColor: Colors.black,
        toolbarWidgetColor: Colors.white,
        lockAspectRatio: true,
        hideBottomControls: true,
      )
    ]);
    if (croppedImage == null) {
      return;
    }

    await AuthService.updateProfilePicture(File(croppedImage.path));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> profileSettings = [
      {
        "leading": FontAwesomeIcons.user,
        "title": "Edit Profile",
        "trailing": const Icon(Icons.arrow_forward_ios_rounded),
      },
      {
        "leading": FontAwesomeIcons.lock,
        "title": "Privay Policy",
        "trailing": const Icon(Icons.arrow_forward_ios_rounded),
        "onTap": () {
          Navigator.pushNamed(context, PrivacyPolicyScreen.routeName);

        },
      },
      {
        "leading": Icons.help_center_outlined,
        "title": "Help Center",
        "onTap": () {
          Navigator.pushNamed(context, HelpCenterScreen.routeName);
        },
        "trailing": const Icon(Icons.arrow_forward_ios_rounded),
      },
      {
        "leading": FontAwesomeIcons.arrowRightFromBracket,
        "title": "Logout",
        "onTap": () {
          AuthService.signOut();
        }
      },
    ];
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        body: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                FirebaseAuth.instance.currentUser!.photoURL == null
                    ? CircleAvatar(
                        minRadius: MediaQuery.of(context).size.width / 8,
                        maxRadius: MediaQuery.of(context).size.width / 8,
                        child: Text(
                          FirebaseAuth.instance.currentUser!.displayName ?? 'U',
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 16),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(9999),
                        child: Image.network(
                          FirebaseAuth.instance.currentUser!.photoURL ?? '',
                          width: MediaQuery.of(context).size.width / 4,
                        ),
                      ),
                GestureDetector(
                  onTap: updateProfilePicture,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.black),
                    child: const Icon(
                      FontAwesomeIcons.pen,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 5),
            Text(
              FirebaseAuth.instance.currentUser!.displayName ?? 'Unknown',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Divider(thickness: 1),
            Expanded(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  ...profileSettings
                      .map(
                        (e) => ListTile(
                          onTap: e['onTap'],
                          trailing: e['trailing'],
                          title: Text(
                            e['title'],
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: e['title'] == 'Logout'
                                        ? Colors.red
                                        : Colors.black),
                          ),
                          leading: Icon(
                            e['leading'],
                            color: e['title'] == "Logout"
                                ? Colors.red
                                : Colors.black,
                          ),
                        ),
                      )
                      .toList()
                ],
              ),
            ),
          ],
        ));
  }
}
