import 'package:app/components/field.dart';
import 'package:app/pages/menu/add.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Display extends StatefulWidget {
  const Display({super.key, required this.onEdit});

  final Function(Map<String, dynamic>) onEdit;

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
      final response = await supabase.from('users').select();
      final fetchedUsers = List<Map<String, dynamic>>.from(response);

      setState(() {
        users = fetchedUsers;
        filteredUsers = fetchedUsers;
      });
    } catch (error) {
      debugPrint('Error fetching users: $error');
    }
  }

  Future<void> deleteUser(String telephone, String? imageUrl) async {
    try {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Suppresion en cours...')),
        );
      }

      final supabase = Supabase.instance.client;
      // delete textual data
      await supabase.from('users').delete().eq('telephone', telephone);

      // delete image
      final imagePath = imageUrl!.split("/").last;
      debugPrint('imagePath: $imagePath');
      await supabase.storage.from('images').remove([imagePath]);

      fetchUsers();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Membre supprimé avec succès!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      debugPrint('Error delete: $e');
    }
  }

  void filterUsers(String query) {
    setState(() {
      filteredUsers = users.where((user) {
        final prenom = user['prenom']?.toString().toLowerCase() ?? '';
        final nom = user['nom']?.toString().toLowerCase() ?? '';
        final numero = user["telephone"] ?? '';
        final mention = user["mention"]?.toString().toLowerCase() ?? '';
        final quartier = user["quartier"]?.toString().toLowerCase() ?? '';
        return prenom.contains(query.toLowerCase()) ||
            nom.contains(query.toLowerCase()) ||
            numero.contains(query) ||
            mention.contains(query.toLowerCase()) ||
            quartier.contains(query.toLowerCase());
      }).toList();
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
            onChanged: filterUsers,
          ),
        ),
        Expanded(
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
                            onPressed: () {
                              widget.onEdit(user);
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.blue[300],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
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
                                          deleteUser(user['telephone'],
                                              user['profile_image_url']);
                                          Navigator.of(context).pop();
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
                      title: Text('${user['nom']} ${user['prenom']}'),
                      subtitle:
                          Text("${user['telephone']} | ${user['adresse']}"),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
