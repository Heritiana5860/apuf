import 'package:app/components/text.dart';
import 'package:flutter/material.dart';

class Display extends StatelessWidget {
  const Display({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextWidget(label: "Liste des membres"),
    );
  }
}