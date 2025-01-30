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

  void _selectPage(DrawerSelections selection) {
    setState(() {
      currentPage = selection;
    });
    Navigator.of(context).pop(); 
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Container();
    if (currentPage == DrawerSelections.addMember) {
      body = AddMember();
    } else if (currentPage == DrawerSelections.display) {
      body = Display();
    } else if (currentPage == DrawerSelections.help) {
      body = Help();
    } else if (currentPage == DrawerSelections.setting) {
      body = Setting();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF52575D),
        foregroundColor: Colors.white,
        title: TextWidget(label: "APUF"),
      ),
      drawer: DrawerWidget(onSelectPage: _selectPage),
      body: body,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF52575D),
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white, size: 25),
      ),
    );
  }
}
