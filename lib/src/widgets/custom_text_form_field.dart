import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final void Function(String)? onChanged;
  final bool obscureText;
  final void Function()? onPressedSuffixIcon;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  const CustomTextFormField(
      {Key? key,
      this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      this.onChanged,
      this.obscureText = false,
      this.keyboardType = TextInputType.text,
      this.onSaved,
      this.validator,
      this.onPressedSuffixIcon,
      this.controller})
      : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _isTyping = false;
  void onChangedValue(String value) {
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
    if (value.trim() == '') {
      setState(() {
        _isTyping = false;
      });
    } else {
      setState(() {
        _isTyping = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        onSaved: widget.onSaved,
        keyboardType: widget.keyboardType,
        onChanged: onChangedValue,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(15)),
          errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(15)),
          filled: true,
          border: InputBorder.none,
          prefixIcon: Icon(
            widget.prefixIcon,
            color: _isTyping ? Colors.black : Colors.grey,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              widget.suffixIcon,
              color: _isTyping ? Colors.black : Colors.grey,
            ),
            onPressed: widget.onPressedSuffixIcon,
          ),
          hintStyle:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
        ),
        obscureText: widget.obscureText,
        cursorColor: Colors.black,
        cursorHeight: 20,
      ),
    );
  }
}
