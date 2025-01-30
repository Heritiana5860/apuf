import 'package:app/components/text.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        foregroundColor: Colors.white,
      ),
      drawer: DrawerWidget(),
      body: Center(
        child: TextWidget(label: "Home"),
      ),
    );
  }
}

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF52575D),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage("assets/img/logoapu.jpeg"),
                  radius: 50,
                ),
                SizedBox(
                  height: 6,
                ),
                TextWidget(
                  label: 'Université de Fianarantsoa',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
          ListTileWidget(
            label: 'Ajouter un membre',
            icon: Icons.add_box_rounded,
          ),
          ListTileWidget(
            label: 'Liste des membres',
            icon: Icons.list_alt_rounded,
          ),
          ListTileWidget(
            label: 'Aide',
            icon: Icons.help,
          ),
          ListTileWidget(
            label: 'Paramètre',
            icon: Icons.settings,
          ),
          ListTileWidget(
            label: 'Deconnexion',
            icon: Icons.logout_outlined,
          ),
        ],
      ),
    );
  }
}

class ListTileWidget extends StatelessWidget {
  const ListTileWidget({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
  });

  final String label;
  final IconData? icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(2),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
            ),
            child: Row(
              children: [
                if (icon != null)
                  Icon(icon, color: Colors.blueAccent, size: 28),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
