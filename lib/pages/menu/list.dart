import 'package:app/components/field.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Display extends StatefulWidget {
  const Display({super.key});

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('users')
          .select('prenom, nom, email, profile_image_url');
      final users = List<Map<String, dynamic>>.from(response);

      // Ensure all users have valid profile_image_url fields
      return users.map((user) {
        if (user['profile_image_url'] == null ||
            user['profile_image_url'].isEmpty) {
          return {
            ...user,
            'profile_image_url': null, // Set to null if no image exists
          };
        }
        return user;
      }).toList();
    } catch (error) {
      debugPrint('Error fetching users: $error');
      return [];
    }
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
            labelText: "Rechercher un membre...",
            suffixIcon: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                size: 30,
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || snapshot.data == null) {
                  return Center(
                    child: Text('Error loading users: ${snapshot.error}'),
                  );
                }
                if (snapshot.data!.isEmpty) {
                  return const Center(child: Text('No users found'));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final user = snapshot.data![index];
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
                            onPressed: () {},
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
                      subtitle: Text(user['email']),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
