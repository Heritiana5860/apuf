import 'package:app/components/text.dart';
import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextWidget(label: "Help"),
    );
  }
}