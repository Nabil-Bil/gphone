import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../helpers/auth_service.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({Key? key}) : super(key: key);

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
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
    return Stack(
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
            : Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(
                        color: Colors.black,
                        width: 2,
                        style: BorderStyle.solid)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9999),
                  child: Image.network(
                    FirebaseAuth.instance.currentUser!.photoURL ?? '',
                    width: MediaQuery.of(context).size.width / 4,
                  ),
                ),
              ),
        GestureDetector(
          onTap: updateProfilePicture,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6), color: Colors.black),
            child: const Icon(
              FontAwesomeIcons.pen,
              size: 15,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
