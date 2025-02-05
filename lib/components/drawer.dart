import 'package:app/components/list_tile.dart';
import 'package:app/components/text.dart';
import 'package:app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key, required this.onSelectPage});

  final Function(DrawerSelections) onSelectPage;

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
            onTap: () => onSelectPage(DrawerSelections.addMember),
          ),
          ListTileWidget(
            label: 'Liste des membres',
            icon: Icons.list_alt_rounded,
            onTap: () => onSelectPage(DrawerSelections.display),
          ),
          ListTileWidget(
              label: 'Aide',
              icon: Icons.help,
              onTap: () => onSelectPage(DrawerSelections.help)),
          ListTileWidget(
            label: 'Paramètre',
            icon: Icons.settings,
            onTap: () => onSelectPage(DrawerSelections.setting),
          ),
          ListTileWidget(
            label: 'Deconnexion',
            icon: Icons.logout_outlined,
            onTap: () async {
              try {
                // Get the Supabase client instance
                final supabase = Supabase.instance.client;

                // Perform the sign-out operation
                await supabase.auth.signOut();

                // Optionally, navigate the user back to the login screen or home page
                Navigator.of(context).pushReplacementNamed('/login');
              } catch (error) {
                // Handle any errors that occur during sign-out
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erreur lors de la déconnexion : $error'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
