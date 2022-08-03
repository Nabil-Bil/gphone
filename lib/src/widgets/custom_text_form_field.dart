import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final bool obscureText;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final bool enabled;
  final bool readOnly;
  final Function()? onTap;

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
      this.controller,
      this.enabled = true,
      this.onTap,
      this.readOnly = false})
      : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _isTyping = false;

  @override
  void initState() {
    if (widget.controller != null) {
      if (widget.controller!.text.trim() == '') {
        _isTyping = false;
      } else {
        _isTyping = true;
      }
      widget.controller!.addListener(() {
        print(widget.controller);

        setState(() {
          if (widget.controller!.text.trim() == '') {
            _isTyping = false;
          } else {
            _isTyping = true;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      child: TextFormField(
        readOnly: widget.readOnly,
        onTap: widget.onTap,
        controller: widget.controller,
        validator: widget.validator,
        onSaved: widget.onSaved,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
            enabled: widget.enabled,
            hintText: widget.hintText,
            prefixIcon: Icon(
              widget.prefixIcon,
              color: _isTyping ? Colors.black : Colors.grey,
            ),
            suffixIcon: widget.suffixIcon),
        obscureText: widget.obscureText,
        cursorHeight: 20,
      ),
    );
  }
}
