import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DropdownWidget extends StatefulWidget {
  const DropdownWidget({
    super.key,
    required this.dropdownLabel,
    required this.jsonFilePath,
    required this.jsonFileOption,
    required this.onValueChanged,
    this.initialValue, // Add initialValue parameter
  });

  final String dropdownLabel;
  final String jsonFileOption;
  final String jsonFilePath;
  final Function(String) onValueChanged;
  final String? initialValue; // Add this field

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  String? dropdownValue;
  List<String> dropdownOptions = [];
  bool isLoading = true; // Add loading state

  @override
  void initState() {
    super.initState();
    loadDropdownOptions();
  }

  @override
  void didUpdateWidget(DropdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update value if initialValue changes
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        dropdownValue = widget.initialValue;
      });
    }
  }

  Future<void> loadDropdownOptions() async {
    try {
      String jsonString = await rootBundle.loadString(widget.jsonFilePath);
      Map<String, dynamic> jsonData = json.decode(jsonString);

      if (mounted) {
        setState(() {
          dropdownOptions = List<String>.from(jsonData[widget.jsonFileOption]);
          // Set initial value in this order: initialValue -> first option -> null
          dropdownValue = widget.initialValue ??
              (dropdownOptions.isNotEmpty ? dropdownOptions[0] : null);
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        debugPrint('Error loading dropdown options: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: widget.dropdownLabel,
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
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.red[400]!,
                    width: 2,
                  ),
                ),
              ),
              value: dropdownValue,
              icon: const Icon(Icons.arrow_drop_down),
              style: TextStyle(color: Colors.grey[600]!),
              isExpanded: true, // Make dropdown take full width
              validator: (value) =>
                  value == null ? '${widget.dropdownLabel} est requis' : null,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                  widget.onValueChanged(newValue);
                }
              },
              items:
                  dropdownOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
