import 'package:app/components/field.dart';
import 'package:app/components/text.dart';
import 'package:app/pages/no_connection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Display extends StatefulWidget {
  const Display({super.key, required this.onEdit});

  final Function(Map<String, dynamic>) onEdit;

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final searchController = TextEditingController();
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  bool _isDeleting = false;

  Future<void> fetchUsers() async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase.from('users').select();
      setState(() {
        users = List<Map<String, dynamic>>.from(response);
        filteredUsers = users;
      });
    } catch (error) {
      debugPrint('Erreur lors du chargement des utilisateurs : $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du chargement des utilisateurs'),
        ),
      );
    }
  }

  Future<void> deleteUser(String telephone, String? imageUrl) async {
    try {
      if (!mounted) return;

      setState(() {
        _isDeleting = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Suppression en cours...')),
      );

      final supabase = Supabase.instance.client;

      // Delete textual data
      await supabase.from('users').delete().eq('telephone', telephone);

      // Delete image
      if (imageUrl != null) {
        final uri = Uri.parse(imageUrl);
        final fileName = uri.pathSegments.last;

        await supabase.storage.from('images').remove([fileName]);
      }

      // Refresh user list
      await fetchUsers();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Membre supprimé avec succès!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la suppression : $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  void filterUsers(String query) {
    setState(() {
      filteredUsers = users.where((user) {
        final prenom = user['prenom']?.toString().toLowerCase() ?? '';
        final nom = user['nom']?.toString().toLowerCase() ?? '';
        final numero = user["telephone"]?.toString() ?? '';
        final mention = user["mention"]?.toString().toLowerCase() ?? '';
        final quartier = user["quartier"]?.toString().toLowerCase() ?? '';
        return prenom.contains(query.toLowerCase()) ||
            nom.contains(query.toLowerCase()) ||
            numero.contains(query.toLowerCase()) ||
            mention.contains(query.toLowerCase()) ||
            quartier.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();

    _initConnectivity();

    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      setState(() {
        _connectionStatus = results.first;
      });
    });
  }

  Future<void> _initConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      _connectionStatus = result.first;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _connectionStatus != ConnectivityResult.none
        ? Stack(
            children: [
              Column(
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
                    child: AbsorbPointer(
                      absorbing: _isDeleting,
                      child: Opacity(
                        opacity: _isDeleting ? 0.6 : 1.0,
                        child: users.isEmpty
                            ? const Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.group_off_sharp,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                    TextWidget(
                                      label: "Aucun membre trouvé.",
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: filteredUsers.length,
                                itemBuilder: (context, index) {
                                  final user = filteredUsers[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    elevation: 0,
                                    child: ListTile(
                                      leading: ClipOval(
                                        child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: user['profile_image_url'] !=
                                                  null
                                              ? Image.network(
                                                  user['profile_image_url'],
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    }
                                                    return const Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  },
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Container(
                                                      color: Colors.grey[300],
                                                      child: const Icon(
                                                          Icons.person),
                                                    );
                                                  },
                                                )
                                              : Container(
                                                  color: Colors.grey[300],
                                                  child:
                                                      const Icon(Icons.person),
                                                ),
                                        ),
                                      ),
                                      title: Text(
                                        '${user['nom']} ${user['prenom']}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        "${user['telephone']} | ${user['adresse']}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () =>
                                                widget.onEdit(user),
                                            icon: Icon(Icons.edit,
                                                color: Colors.blue[300]),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    shape:
                                                        ContinuousRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4)),
                                                    title: const TextWidget(
                                                        label:
                                                            'Confirmer la suppression'),
                                                    content: const TextWidget(
                                                        label:
                                                            'Voulez-vous vraiment supprimer cet utilisateur ?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: const TextWidget(
                                                          label: 'Annuler',
                                                          color: Colors.black45,
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          deleteUser(
                                                              user['telephone'],
                                                              user[
                                                                  'profile_image_url']);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const TextWidget(
                                                          label: 'Supprimer',
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            icon: Icon(Icons.delete,
                                                color: Colors.red[300]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_isDeleting)
                Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Color(0xFF52575D),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Suppression en cours...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          )
        : NoConnection();
  }
}
