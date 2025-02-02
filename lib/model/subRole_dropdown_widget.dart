import 'package:flutter/material.dart';

class SubRoleDropdownWidget extends StatefulWidget {
  final String? selectedCategory;

  const SubRoleDropdownWidget({
    super.key,
    required this.selectedCategory,
  });

  @override
  State<SubRoleDropdownWidget> createState() => _SubRoleDropdownWidgetState();
}

class _SubRoleDropdownWidgetState extends State<SubRoleDropdownWidget> {
  String? selectedRole;
  Map<String, List<String>> roleMap = {
    "Birao": [
      "Commissaire au compte",
      "Conseiller 1",
      "Conseiller 2",
      "Exterieur",
      "Interior",
      "Président",
      "Secrétaire 1",
      "Secrétaire 2",
      "Trésorier(e)",
      "Vice-Président"
    ],
    "Komity": [
      "Communication",
      "Materiel",
      "Pedagogie",
      "Sonorisation",
      "Spirituel",
      "Sport"
    ],
    "Kristianina": ["Tsotra"],
  };

  @override
  void didUpdateWidget(SubRoleDropdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCategory != oldWidget.selectedCategory) {
      setState(() {
        selectedRole = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final roles = widget.selectedCategory != null
        ? roleMap[widget.selectedCategory] ?? []
        : <String>[];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: "Rôle",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey[400]!,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey[400]!,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.blueAccent,
              width: 2.0,
            ),
          ),
        ),
        value: selectedRole,
        hint: const Text("Sélectionnez un rôle"),
        icon: const Icon(Icons.arrow_drop_down),
        style: TextStyle(color: Colors.grey[600]!),
        onChanged: widget.selectedCategory == null
            ? null
            : (String? newValue) {
                setState(() {
                  selectedRole = newValue;
                });
              },
        items: roles.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
