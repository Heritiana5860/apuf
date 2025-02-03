import 'package:app/components/datepicker.dart';
import 'package:app/components/dropdown.dart';
import 'package:app/components/field.dart';
import 'package:app/model/member_model.dart';
import 'package:app/model/role_dropdown_widget.dart';
import 'package:app/model/subRole_dropdown_widget.dart';
import 'package:app/services/auth_state.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class AddMember extends StatefulWidget {
  const AddMember({super.key, this.memberToEdit});

  final Map<String, dynamic>? memberToEdit;

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  File? _image;
  final _formKey = GlobalKey<FormState>();
  String? selectedCategory;
  final supabase = Supabase.instance.client;

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

  @override
  Widget build(BuildContext context) {
    final bool isFormFilled = _areAllFieldsFilled();
    return AuthRequired(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Photo de profil
              GestureDetector(
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
                        ? Image.file(_image!,
                            fit: BoxFit.cover, width: 130, height: 130)
                        : Icon(Icons.add_a_photo_rounded,
                            size: 50, color: Colors.grey[800]),
                  ),
                ),
              ),

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
                            p0 == null || p0.isEmpty ? "Nom requis" : null,
                      ),

                      // Prénom
                      FieldWidget(
                        obscureText: false,
                        labelText: "Prénom",
                        icon: Icons.person,
                        controller: prenomController,
                        validator: (p0) =>
                            p0 == null || p0.isEmpty ? "Prénom requis" : null,
                      ),

                      // Téléphone
                      FieldWidget(
                        obscureText: false,
                        labelText: "Téléphone",
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        controller: telephoneController,
                        validator: (p0) => p0 == null || p0.isEmpty
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
                            p0 == null || p0.isEmpty ? "Email requis" : null,
                      ),

                      // Facebook
                      FieldWidget(
                        obscureText: false,
                        labelText: "Facebook",
                        icon: Icons.facebook,
                        controller: facebookController,
                        validator: (p0) =>
                            p0 == null || p0.isEmpty ? "Facebook requis" : null,
                      ),

                      // Date et Lieu de naissance
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              validator: (p0) => p0 == null || p0.isEmpty
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
                        jsonFilePath: 'assets/json/etablissement.json',
                        onValueChanged: (value) {
                          setState(() {
                            selectedEtablissement = value;
                          });
                        },
                      ),

                      // Parcours et Niveau
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: DropdownWidget(
                              dropdownLabel: 'Mention',
                              jsonFileOption: 'mention',
                              jsonFilePath: 'assets/json/mention.json',
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
                              jsonFilePath: 'assets/json/niveau.json',
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
                            p0 == null || p0.isEmpty ? "Adresse requise" : null,
                      ),

                      // Adresse et Quartier
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: DropdownWidget(
                              dropdownLabel: 'Quartier',
                              jsonFileOption: 'quartier',
                              jsonFilePath: 'assets/json/quartier.json',
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
                              jsonFilePath: 'assets/json/sexe.json',
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              jsonFilePath: 'assets/json/eglise.json',
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
                            onCategorySelected: (category) {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                          ),
                          SubRoleDropdownWidget(
                            selectedCategory: selectedCategory,
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
                            p0 == null || p0.isEmpty ? "Fiaviana requis" : null,
                      ),

                      // Mpandray et Sampana
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: DropdownWidget(
                              dropdownLabel: 'Mpandray',
                              jsonFileOption: 'mpandray',
                              jsonFilePath: 'assets/json/mpandray.json',
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
                              jsonFilePath: 'assets/json/reception.json',
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
                            p0 == null || p0.isEmpty ? "Talenta requis" : null,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Bouton d'ajout
        floatingActionButton: FloatingActionButton(
          backgroundColor: isFormFilled ? const Color(0xFF52575D) : Colors.grey,
          onPressed: isFormFilled
              ? () {
                  if (_formKey.currentState!.validate()) {
                    saveUserData();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Membre ajouté avec succès!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                }
              : null,
          child: Icon(Icons.add, color: Colors.white, size: 25),
        ),
      ),
    );
  }

  Future<String?> uploadImage(File imageFile, String userId) async {
    try {
      // Create a unique file name using user ID and timestamp
      final fileExt = imageFile.path.split('.').last;
      final fileName = 'profile_$userId.$fileExt';
      final bucketName = 'images';

      // Upload the image
      await supabase.storage.from(bucketName).upload(
            'profiles/$fileName', // Store in a 'profiles' folder for better organization
            imageFile,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
            ),
          );

      // Get the public URL
      final imageUrl =
          supabase.storage.from(bucketName).getPublicUrl('profiles/$fileName');

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

      // Show loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sauvegarde en cours...')),
        );
      }

      // Generate a unique ID for the user
      final userId = DateTime.now().millisecondsSinceEpoch.toString();
      String? imageUrl;

      // Upload image if exists
      if (_image != null) {
        imageUrl = await uploadImage(_image!, userId);
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
        mpandray: selectedMpandray,
        reception: selectedReception,
        sampana: selectedSampana,
        profileImageUrl: imageUrl,
      );

      // Save to database using upsert
      await supabase.from('users').upsert(member.toJson());

      if (mounted) {
        _resetForm();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Membre ajouté avec succès!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back or clear form
        //Navigator.of(context).pop();
      }
    } on PostgrestException catch (error) {
      if (mounted) {
        debugPrint('Erreur de base de données: ${error.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de base de données'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on StorageException catch (error) {
      if (mounted) {
        debugPrint('Erreur de stockage: ${error.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de stockage'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        debugPrint('Erreur inattendue: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur inattendue'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
}
