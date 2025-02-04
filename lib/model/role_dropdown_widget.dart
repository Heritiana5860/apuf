import 'package:flutter/material.dart';

class RoleDropdownWidget extends StatefulWidget {
  final Function(String?) onCategorySelected;
  final String? initialValue;

  const RoleDropdownWidget({
    super.key,
    required this.onCategorySelected,
    this.initialValue,
  });

  @override
  State<RoleDropdownWidget> createState() => _RoleDropdownWidgetState();
}

class _RoleDropdownWidgetState extends State<RoleDropdownWidget> {
  String? selectedCategory;
  List<String> categories = ["Birao", "Komity", "Kristianina"];

  @override
  void initState() {
    super.initState();
    // Initialize with the provided value
    selectedCategory = widget.initialValue;
  }

  @override
  void didUpdateWidget(RoleDropdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update value if initialValue changes
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        selectedCategory = widget.initialValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: "Catégorie",
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
        value: selectedCategory,
        hint: const Text("Sélectionnez une catégorie"),
        icon: const Icon(Icons.arrow_drop_down),
        style: TextStyle(color: Colors.grey[600]!),
        isExpanded: true,
        onChanged: (String? newValue) {
          setState(() {
            selectedCategory = newValue;
            widget.onCategorySelected(newValue);
          });
        },
        items: categories.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
