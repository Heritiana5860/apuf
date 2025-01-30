import 'package:app/components/text.dart';
import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextWidget(label: "Setting"),
    );
  }
}