import 'package:app/components/datepicker.dart';
import 'package:app/components/dropdown.dart';
import 'package:app/components/field.dart';
import 'package:app/model/member_model.dart';
import 'package:app/model/role_dropdown_widget.dart';
import 'package:app/model/subRole_dropdown_widget.dart';
import 'package:app/pages/no_connection.dart';
import 'package:app/services/auth_state.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;

class AddMember extends StatefulWidget {
  const AddMember({super.key, this.memberToEdit, this.onSave});

  final Map<String, dynamic>? memberToEdit;
  final VoidCallback? onSave;

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  File? _image;
  final _formKey = GlobalKey<FormState>();
  String? selectedCategory;
  String? selectedRole;
  final supabase = Supabase.instance.client;
  bool isEditing = false;
  String? existingImageUrl;
  bool _isSaving = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  final telephoneController = TextEditingController();
  final emailController = TextEditingController();
  final facebookController = TextEditingController();
  final lieuController = TextEditingController();
  final adresseController = TextEditingController();
  final fiavianaController = TextEditingController();
  final talentaController = TextEditingController();

  DateTime dateDeNaissance = DateTime.now();
  DateTime dateDentree = DateTime.now();

  String? selectedEtablissement;
  String? selectedMention;
  String? selectedNiveau;
  String? selectedQuartier;
  String? selectedSexe;
  String? selectedEglise;
  String? selectedMpandray;
  String? selectedReception;
  String? selectedSampana;

  bool _areAllFieldsFilled() {
    return nomController.text.isNotEmpty &&
        prenomController.text.isNotEmpty &&
        telephoneController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        facebookController.text.isNotEmpty &&
        lieuController.text.isNotEmpty &&
        adresseController.text.isNotEmpty &&
        fiavianaController.text.isNotEmpty &&
        talentaController.text.isNotEmpty &&
        selectedEtablissement != null &&
        selectedMention != null &&
        selectedNiveau != null &&
        selectedQuartier != null &&
        selectedSexe != null &&
        selectedEglise != null &&
        selectedMpandray != null &&
        selectedReception != null &&
        selectedSampana != null &&
        selectedCategory != null;
  }

  @override
  void initState() {
    super.initState();

    if (widget.memberToEdit != null) {
      isEditing = true;
      _initializeEditData();
    }

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
    // Dispose controllers
    nomController.dispose();
    prenomController.dispose();
    telephoneController.dispose();
    emailController.dispose();
    facebookController.dispose();
    lieuController.dispose();
    adresseController.dispose();
    fiavianaController.dispose();
    talentaController.dispose();

    super.dispose();
  }

  void _initializeEditData() {
    final member = widget.memberToEdit!;
    nomController.text = member['nom'] ?? '';
    prenomController.text = member['prenom'] ?? '';
    telephoneController.text = member['telephone'] ?? '';
    emailController.text = member['email'] ?? '';
    facebookController.text = member['facebook'] ?? '';
    lieuController.text = member['lieu_de_naissance'] ?? '';
    adresseController.text = member['adresse'] ?? '';
    fiavianaController.text = member['fiaviana'] ?? '';
    talentaController.text = member['talenta'] ?? '';

    // Initialize dropdowns
    setState(() {
      selectedEtablissement = member['etablissement'];
      selectedMention = member['mention'];
      selectedNiveau = member['niveau'];
      selectedQuartier = member['quartier'];
      selectedSexe = member['sexe'];
      selectedEglise = member['eglise'];
      selectedMpandray = member['mpandray'];
      selectedReception = member['reception'];
      selectedSampana = member['sampana'];
      selectedRole = member['category'];
      selectedCategory = member['role'];
      existingImageUrl = member['profile_image_url'];
    });

    // Initialize dates
    if (member['date_de_naissance'] != null) {
      dateDeNaissance = DateTime.parse(member['date_de_naissance']);
    }
    if (member['date_entree'] != null) {
      dateDentree = DateTime.parse(member['date_entree']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isFormFilled = _areAllFieldsFilled();
    return _connectionStatus != ConnectivityResult.none
        ? AuthRequired(
            child: Scaffold(
              backgroundColor: Colors.grey[200],
              body: Stack(
                children: [
                  AbsorbPointer(
                    absorbing: _isSaving,
                    child: SingleChildScrollView(
                      child: Opacity(
                        opacity: _isSaving ? 0.6 : 1.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),

                            // Photo de profil
                            photoDeProfile(),

                            // Formulaire
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    // Nom
                                    FieldWidget(
                                      obscureText: false,
                                      labelText: "Nom",
                                      icon: Icons.person,
                                      controller: nomController,
                                      validator: (p0) =>
                                          p0 == null || p0.isEmpty
                                              ? "Nom requis"
                                              : null,
                                    ),

                                    // Prénom
                                    FieldWidget(
                                      obscureText: false,
                                      labelText: "Prénom",
                                      icon: Icons.person,
                                      controller: prenomController,
                                      validator: (p0) =>
                                          p0 == null || p0.isEmpty
                                              ? "Prénom requis"
                                              : null,
                                    ),

                                    // Téléphone
                                    FieldWidget(
                                      obscureText: false,
                                      labelText: "Téléphone",
                                      icon: Icons.phone,
                                      keyboardType: TextInputType.phone,
                                      controller: telephoneController,
                                      validator: (p0) =>
                                          p0 == null || p0.isEmpty
                                              ? "Téléphone requis"
                                              : null,
                                    ),

                                    // Email
                                    FieldWidget(
                                      obscureText: false,
                                      labelText: "Email",
                                      keyboardType: TextInputType.emailAddress,
                                      icon: Icons.email,
                                      controller: emailController,
                                      validator: (p0) =>
                                          p0 == null || p0.isEmpty
                                              ? "Email requis"
                                              : null,
                                    ),

                                    // Facebook
                                    FieldWidget(
                                      obscureText: false,
                                      labelText: "Facebook",
                                      icon: Icons.facebook,
                                      controller: facebookController,
                                      validator: (p0) =>
                                          p0 == null || p0.isEmpty
                                              ? "Facebook requis"
                                              : null,
                                    ),

                                    // Date et Lieu de naissance
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: DatepickerWidget(
                                          labelText: "Date de naissance",
                                          onDateSelected: (DateTime date) {
                                            setState(() {
                                              dateDeNaissance = date;
                                            });
                                          },
                                        )),
                                        Expanded(
                                          child: FieldWidget(
                                            obscureText: false,
                                            labelText: "Lieu de naissance",
                                            icon: Icons.place,
                                            controller: lieuController,
                                            validator: (p0) =>
                                                p0 == null || p0.isEmpty
                                                    ? "Lieu requis"
                                                    : null,
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Etablissement
                                    DropdownWidget(
                                      dropdownLabel: 'Etablissement',
                                      jsonFileOption: 'etablissement',
                                      jsonFilePath:
                                          'assets/json/etablissement.json',
                                      initialValue: selectedEtablissement,
                                      onValueChanged: (value) {
                                        setState(() {
                                          selectedEtablissement = value;
                                        });
                                      },
                                    ),

                                    // Parcours et Niveau
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: DropdownWidget(
                                            dropdownLabel: 'Mention',
                                            jsonFileOption: 'mention',
                                            jsonFilePath:
                                                'assets/json/mention.json',
                                            initialValue: selectedMention,
                                            onValueChanged: (value) {
                                              setState(() {
                                                selectedMention = value;
                                              });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          child: DropdownWidget(
                                            dropdownLabel: 'Niveau',
                                            jsonFileOption: 'niveau',
                                            jsonFilePath:
                                                'assets/json/niveau.json',
                                            initialValue: selectedNiveau,
                                            onValueChanged: (value) {
                                              setState(() {
                                                selectedNiveau = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Adresse
                                    FieldWidget(
                                      obscureText: false,
                                      labelText: "Adresse",
                                      icon: Icons.location_city,
                                      controller: adresseController,
                                      validator: (p0) =>
                                          p0 == null || p0.isEmpty
                                              ? "Adresse requise"
                                              : null,
                                    ),

                                    // Adresse et Quartier
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: DropdownWidget(
                                            dropdownLabel: 'Quartier',
                                            jsonFileOption: 'quartier',
                                            jsonFilePath:
                                                'assets/json/quartier.json',
                                            initialValue: selectedQuartier,
                                            onValueChanged: (value) {
                                              setState(() {
                                                selectedQuartier = value;
                                              });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          // Sexe
                                          child: DropdownWidget(
                                            dropdownLabel: "Sexe",
                                            jsonFileOption: 'sexe',
                                            jsonFilePath:
                                                'assets/json/sexe.json',
                                            initialValue: selectedSexe,
                                            onValueChanged: (value) {
                                              setState(() {
                                                selectedSexe = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Date d'entrée et église
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: DatepickerWidget(
                                          labelText: "Date d'entrée",
                                          onDateSelected: (DateTime date) {
                                            setState(() {
                                              dateDentree = date;
                                            });
                                          },
                                        )),
                                        Expanded(
                                          child: DropdownWidget(
                                            dropdownLabel: "Eglise",
                                            jsonFileOption: 'eglise',
                                            jsonFilePath:
                                                'assets/json/eglise.json',
                                            initialValue: selectedEglise,
                                            onValueChanged: (value) {
                                              setState(() {
                                                selectedEglise = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Rôle
                                    Column(
                                      children: [
                                        RoleDropdownWidget(
                                          initialValue: selectedCategory,
                                          onCategorySelected: (category) {
                                            setState(() {
                                              selectedCategory = category;
                                              //selectedRole = null;
                                            });
                                          },
                                        ),
                                        SubRoleDropdownWidget(
                                          selectedCategory: selectedCategory,
                                          initialValue: selectedRole,
                                          onRoleSelected: (role) {
                                            setState(() {
                                              selectedRole = role;
                                            });
                                          },
                                        ),
                                      ],
                                    ),

                                    // Fiaviana (D'où venez-vous ?)
                                    FieldWidget(
                                      obscureText: false,
                                      labelText: "Fiaviana",
                                      icon: Icons.place_outlined,
                                      controller: fiavianaController,
                                      validator: (p0) =>
                                          p0 == null || p0.isEmpty
                                              ? "Fiaviana requis"
                                              : null,
                                    ),

                                    // Mpandray et Sampana
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: DropdownWidget(
                                            dropdownLabel: 'Mpandray',
                                            jsonFileOption: 'mpandray',
                                            jsonFilePath:
                                                'assets/json/mpandray.json',
                                            initialValue: selectedMpandray,
                                            onValueChanged: (value) {
                                              setState(() {
                                                selectedMpandray = value;
                                              });
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          // Réception
                                          child: DropdownWidget(
                                            dropdownLabel: 'Réception',
                                            jsonFileOption: 'reception',
                                            jsonFilePath:
                                                'assets/json/reception.json',
                                            initialValue: selectedReception,
                                            onValueChanged: (value) {
                                              setState(() {
                                                selectedReception = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Sampana
                                    DropdownWidget(
                                      dropdownLabel: 'Sampana',
                                      jsonFileOption: 'sampana',
                                      jsonFilePath: 'assets/json/sampana.json',
                                      initialValue: selectedSampana,
                                      onValueChanged: (value) {
                                        setState(() {
                                          selectedSampana = value;
                                        });
                                      },
                                    ),

                                    // Specialité
                                    FieldWidget(
                                      obscureText: false,
                                      labelText: "Talenta",
                                      icon: Icons.format_align_center,
                                      controller: talentaController,
                                      validator: (p0) =>
                                          p0 == null || p0.isEmpty
                                              ? "Talenta requis"
                                              : null,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_isSaving)
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
                              'Sauvegarde en cours...',
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
              ),

              // Bouton d'ajout
              floatingActionButton: FloatingActionButton(
                backgroundColor:
                    isFormFilled ? const Color(0xFF52575D) : Colors.grey,
                onPressed: isFormFilled
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          saveUserData();
                        }
                      }
                    : null,
                child: Icon(
                  isEditing ? Icons.update : Icons.add,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          )
        : NoConnection();
  }

  GestureDetector photoDeProfile() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey[300]!, width: 3),
          color: Colors.grey[200],
        ),
        child: ClipOval(
          child: _image != null
              ? Image.file(_image!, fit: BoxFit.cover, width: 130, height: 130)
              : (existingImageUrl != null && existingImageUrl!.isNotEmpty
                  ? Image.network(
                      existingImageUrl!,
                      fit: BoxFit.cover,
                      width: 130,
                      height: 130,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Icon(Icons.add_a_photo_rounded,
                              size: 50, color: Colors.grey[800]),
                        );
                      },
                    )
                  : Icon(Icons.add_a_photo_rounded,
                      size: 50, color: Colors.grey[800])),
        ),
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _image = null;
      nomController.clear();
      prenomController.clear();
      telephoneController.clear();
      emailController.clear();
      facebookController.clear();
      lieuController.clear();
      adresseController.clear();
      fiavianaController.clear();
      talentaController.clear();

      // Reset dates to current
      dateDeNaissance = DateTime.now();
      dateDentree = DateTime.now();

      // Reset all dropdowns
      selectedEtablissement = null;
      selectedMention = null;
      selectedNiveau = null;
      selectedQuartier = null;
      selectedSexe = null;
      selectedEglise = null;
      selectedMpandray = null;
      selectedReception = null;
      selectedSampana = null;
      selectedCategory = null;
    });
  }

  Future<String?> uploadImage(File imageFile, String userId) async {
    try {
      // Create a unique file name using user ID and timestamp
      final fileExt = p.extension(imageFile.path);
      final fileName = '$userId$fileExt';
      final bucketName = 'images';

      // Upload the image
      await supabase.storage.from(bucketName).upload(
            fileName,
            imageFile,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
            ),
          );

      // Get the public URL
      final imageUrl = supabase.storage.from(bucketName).getPublicUrl(fileName);

      return imageUrl;
    } on StorageException catch (error) {
      debugPrint('Storage error: ${error.message}');
      rethrow;
    } catch (error) {
      debugPrint('Unexpected error during image upload: $error');
      rethrow;
    }
  }

  Future<void> saveUserData() async {
    try {
      if (!_formKey.currentState!.validate()) {
        throw Exception('Form validation failed');
      }

      setState(() {
        _isSaving = true;
      });

      // Show loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sauvegarde en cours...')),
        );
      }

      String? imageUrl = widget.memberToEdit?['profile_image_url'];

      // Vérifier si une nouvelle image est sélectionnée
      if (_image != null) {
        final userId = widget.memberToEdit?['telephone'] ??
            DateTime.now().millisecondsSinceEpoch.toString();
        final fileExt = _image!.path.split('.').last;
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final newFileName = '${userId}_$timestamp.$fileExt';

        // Supprimer l'ancienne image si elle existe
        if (isEditing && imageUrl != null) {
          await deleteOldImage(imageUrl);
        }

        // Uploader la nouvelle image avec le nouveau nom
        imageUrl = await uploadImage(_image!, newFileName);
      }

      // Prepare member data
      final member = MemberModel(
        user_id: supabase.auth.currentUser!.id,
        nom: nomController.text.trim(),
        prenom: prenomController.text.trim(),
        telephone: telephoneController.text.trim(),
        email: emailController.text.trim(),
        facebook: facebookController.text.trim(),
        dateDeNaissance: dateDeNaissance,
        lieuDeNaissance: lieuController.text.trim(),
        adresse: adresseController.text.trim(),
        dateEntree: dateDentree,
        fiaviana: fiavianaController.text.trim(),
        talenta: talentaController.text.trim(),
        etablissement: selectedEtablissement,
        mention: selectedMention,
        niveau: selectedNiveau,
        quartier: selectedQuartier,
        sexe: selectedSexe,
        eglise: selectedEglise,
        role: selectedCategory,
        category: selectedRole,
        mpandray: selectedMpandray,
        reception: selectedReception,
        sampana: selectedSampana,
        profileImageUrl: imageUrl,
      );

      if (isEditing) {
        // Update existing record
        await supabase
            .from('users')
            .update(member.toJson())
            .eq('telephone', widget.memberToEdit!['telephone']);
        isEditing = false;
        _image = null;
      } else {
        // Insert new record
        await supabase.from('users').insert(member.toJson());
      }

      if (mounted) {
        _resetForm();

        setState(() {
          _isSaving = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing
                ? 'Membre modifié avec succès!'
                : 'Membre ajouté avec succès!'),
            backgroundColor: Colors.green,
          ),
        );

        // Call the onSave callback
        if (widget.onSave != null) {
          widget.onSave!();
        }
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        debugPrint('Erreur: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Une erreur est survenue'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> deleteOldImage(String imageUrl) async {
    try {
      const bucketName = 'images';

      // Extraire le nom du fichier à partir de l'URL publique
      final uri = Uri.parse(imageUrl);
      final fileName = uri.pathSegments.last;

      await supabase.storage.from(bucketName).remove([fileName]);
    } catch (e) {
      debugPrint("Erreur lors de la suppression de l'image: $e");
    }
  }
}
