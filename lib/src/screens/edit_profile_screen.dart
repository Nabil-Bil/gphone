import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_validation/form_validation.dart';
import 'package:gphone/src/helpers/auth_service.dart';
import 'package:gphone/src/widgets/custom_text_form_field.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = "/edit-profile";
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController birthdatyController;
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();
  bool _isLoading = false;

  late DateTime? birthday;
  Future<void> pickBirthDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime(
        DateTime.now().year,
        DateTime.december,
      ),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(primary: Colors.black),
            ),
            child: child!);
      },
      initialDatePickerMode: DatePickerMode.year,
    );
    if (pickedDate == null) {
      return;
    }
    birthday = pickedDate;
    birthdatyController.text = DateFormat("dd/MM/yyyy").format(pickedDate);
  }

  @override
  void initState() {
    final auth = FirebaseAuth.instance.currentUser!;
    birthdatyController = TextEditingController();
    fullNameController = TextEditingController(text: auth.displayName);
    emailController = TextEditingController(text: auth.email);
    birthday = null;
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(auth.uid)
        .get()
        .then((value) {
      try {
        birthday = DateTime.parse(
            (value['birthday'] as Timestamp).toDate().toIso8601String());
        birthdatyController.text = DateFormat("dd/MM/yyyy").format(birthday!);
      } catch (e) {}
    });
  }

  Future<void> updateUserInfo() async {
    bool isValid = _key.currentState!.validate();
    if (isValid) {
      _key.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      try {
        await AuthService.updateUserInfo({
          "fullName": fullNameController.text,
          "email": emailController.text,
          "password": passwordController.text,
          "birthday": birthday,
        });
        if (mounted) Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        final String errorMessage = e.message ?? "Something went Wrong";
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
          content: Text(errorMessage),
          action: SnackBarAction(
              textColor: Colors.white, label: "Hide", onPressed: () {}),
        ));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Builder(builder: (context) {
          return SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomTextFormField(
                      controller: fullNameController,
                      hintText: "Full Name",
                      prefixIcon: FontAwesomeIcons.user,
                      validator: (value) {
                        Validator validator = Validator(validators: [
                          RequiredValidator(),
                          MinLengthValidator(length: 4),
                          MaxLengthValidator(length: 20),
                        ]);
                        return validator.validate(
                            context: context, label: 'Name', value: value);
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      prefixIcon: FontAwesomeIcons.envelope,
                      controller: emailController,
                      hintText: "Email",
                      validator: (value) {
                        Validator validator = Validator(validators: [
                          RequiredValidator(),
                          EmailValidator(),
                        ]);
                        return validator.validate(
                            context: context, label: 'Email', value: value);
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: passwordController,
                      hintText: "Password",
                      prefixIcon: FontAwesomeIcons.lock,
                      validator: (value) {
                        Validator validator = Validator(validators: [
                          MinLengthValidator(length: 5),
                        ]);
                        return validator.validate(
                            context: context, label: 'Password', value: value);
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: birthdatyController,
                      readOnly: true,
                      onTap: () {
                        pickBirthDate();
                      },
                      hintText: "Date of Birth",
                      suffixIcon: IconButton(
                        onPressed: () {
                          pickBirthDate();
                        },
                        icon: const Icon(
                          FontAwesomeIcons.calendar,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              await updateUserInfo();
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Update"),
                          _isLoading
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: CircularProgressIndicator(
                                      color: Colors.white),
                                )
                              : Container()
                        ],
                      ),
                    )
                  ]),
            ),
          );
        }),
      ),
    );
  }
}
