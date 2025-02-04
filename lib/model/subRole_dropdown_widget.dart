import 'package:flutter/material.dart';

class SubRoleDropdownWidget extends StatefulWidget {
  final String? selectedCategory;
  final String? initialValue;
  final Function(String?)? onRoleSelected;

  const SubRoleDropdownWidget({
    super.key,
    required this.selectedCategory,
    this.initialValue,
    this.onRoleSelected,
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
  void initState() {
    super.initState();
    // Initialize with the provided value if it exists in the current category's roles
    if (widget.initialValue != null && widget.selectedCategory != null) {
      final roles = roleMap[widget.selectedCategory] ?? [];
      if (roles.contains(widget.initialValue)) {
        selectedRole = widget.initialValue;
      }
    }
  }

  @override
  void didUpdateWidget(SubRoleDropdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle category changes
    if (widget.selectedCategory != oldWidget.selectedCategory) {
      setState(() {
        // Clear selection when category changes
        selectedRole = null;
      });
    }

    // Handle initialValue changes
    if (widget.initialValue != oldWidget.initialValue &&
        widget.selectedCategory != null) {
      final roles = roleMap[widget.selectedCategory] ?? [];
      if (roles.contains(widget.initialValue)) {
        setState(() {
          selectedRole = widget.initialValue;
        });
      }
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
        isExpanded: true,
        onChanged: widget.selectedCategory == null
            ? null
            : (String? newValue) {
                setState(() {
                  selectedRole = newValue;
                });
                // Call the callback when role changes
                widget.onRoleSelected?.call(newValue);
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
