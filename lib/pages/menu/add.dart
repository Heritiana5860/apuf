import 'package:app/components/text.dart';
import 'package:flutter/material.dart';

class AddMember extends StatefulWidget {
  const AddMember({super.key});

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextWidget(label: "Ajouter un membre"),
    );
  }
}