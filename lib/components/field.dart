import 'package:flutter/material.dart';

class FieldWidget extends StatelessWidget {
  final String? labelText;
  final IconData? icon;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool obscureText;

  const FieldWidget(
      {super.key,
      this.controller,
      this.labelText,
      this.icon,
      required this.obscureText,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          prefixIcon: Icon(icon),
        ),
        validator: validator,
      ),
    );
  }
}
