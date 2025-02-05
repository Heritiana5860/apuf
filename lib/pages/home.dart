import 'package:app/components/drawer.dart';
import 'package:app/components/text.dart';
import 'package:app/pages/menu/add.dart';
import 'package:app/pages/menu/help.dart';
import 'package:app/pages/menu/list.dart';
import 'package:app/pages/menu/setting.dart';
import 'package:flutter/material.dart';

enum DrawerSelections { addMember, display, help, setting }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var currentPage = DrawerSelections.addMember;
  Map<String, dynamic>? memberToEdit;

  void _selectPage(DrawerSelections selection) {
    setState(() {
      currentPage = selection;
      memberToEdit = null;
    });
    Navigator.of(context).pop(); 
  }

  void _editMember(Map<String, dynamic> member) {
    setState(() {
      currentPage = DrawerSelections.addMember;
      memberToEdit = member; 
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Container();
    if (currentPage == DrawerSelections.addMember) {
      body = AddMember(memberToEdit: memberToEdit, onSave: () {
        setState(() {
          memberToEdit = null;
        });
      });
    } else if (currentPage == DrawerSelections.display) {
      body = Display(onEdit: _editMember);
    } else if (currentPage == DrawerSelections.help) {
      body = Help();
    } else if (currentPage == DrawerSelections.setting) {
      body = Setting();
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Color(0xFF52575D),
        foregroundColor: Colors.white,
        title: TextWidget(label: "APUF"),
      ),
      drawer: DrawerWidget(onSelectPage: _selectPage),
      body: body,
    );
  }
}
