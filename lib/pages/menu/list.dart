import 'package:app/components/field.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Display extends StatefulWidget {
  const Display({super.key});

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  final searchController = TextEditingController();
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];

  Future<void> fetchUsers() async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('users')
          .select('prenom, nom, telephone, profile_image_url');
      final fetchedUsers = List<Map<String, dynamic>>.from(response);

      // Assurez-vous que tous les utilisateurs ont des URL d'image valides
      final processedUsers = fetchedUsers.map((user) {
        if (user['profile_image_url'] == null ||
            user['profile_image_url'].isEmpty) {
          return {
            ...user,
            'profile_image_url': null,
          };
        }
        return user;
      }).toList();

      setState(() {
        users = processedUsers;
        filteredUsers = processedUsers;
      });
    } catch (error) {
      debugPrint('Error fetching users: $error');
    }
  }

  Future<void> deleteUser(String telephone) async {
    try {
      final supabase = Supabase.instance.client;

      // Delete the user from the database
      await supabase.from('users').delete().eq('telephone', telephone);

      // Remove the user from local state
      setState(() {
        users.removeWhere((user) => user['telephone'] == telephone);
        filteredUsers.removeWhere((user) => user['telephone'] == telephone);
      });

      // Optional: Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Utilisateur supprimé avec succès')),
      );
    } catch (error) {
      debugPrint('Error deleting user: $error');

      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la suppression de l\'utilisateur'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredUsers = users;
      } else {
        filteredUsers = users.where((user) {
          final prenom = user['prenom']?.toString().toLowerCase() ?? '';
          final nom = user['nom']?.toString().toLowerCase() ?? '';
          final queryLower = query.toLowerCase();
          return prenom.contains(queryLower) || nom.contains(queryLower);
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: FieldWidget(
            obscureText: false,
            icon: Icons.search,
            controller: searchController,
            labelText: "Rechercher un membre...",
            onChanged: (value) {
              filterUsers(value);
            },
          ),
        ),
        Expanded(
          child: Center(
            child: users.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return ListTile(
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blue[300],
                              ),
                            ),
                            const SizedBox(width: 1),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: ContinuousRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      title: Text('Confirmer la suppression'),
                                      content: Text(
                                          'Voulez-vous vraiment supprimer cet utilisateur ?'),
                                      actions: [
                                        TextButton(
                                          child: Text('Annuler'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Supprimer'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            deleteUser(user['telephone']);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red[300],
                              ),
                            ),
                          ],
                        ),
                        leading: ClipOval(
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: user['profile_image_url'] != null
                                ? Image.network(
                                    user['profile_image_url'],
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      debugPrint('Error loading image: $error');
                                      return Container(
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.person),
                                      );
                                    },
                                  )
                                : Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.person),
                                  ),
                          ),
                        ),
                        title: Text('${user['prenom']} ${user['nom']}'),
                        subtitle: Text(user['telephone']),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
