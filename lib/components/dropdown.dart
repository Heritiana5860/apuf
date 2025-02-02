import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DropdownWidget extends StatefulWidget {
  const DropdownWidget(
      {super.key,
      required this.dropdownLabel,
      required this.jsonFilePath,
      required this.jsonFileOption,
      required this.onValueChanged,
      });

  final String dropdownLabel;
  final String jsonFileOption;
  final String jsonFilePath;
  final Function(String) onValueChanged;

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  String? dropdownValue;
  List<String> dropdownOptions = [];

  @override
  void initState() {
    super.initState();
    loadDropdownOptions();
  }

  Future<void> loadDropdownOptions() async {
    String jsonString = await rootBundle.loadString(widget.jsonFilePath);
    Map<String, dynamic> jsonData = json.decode(jsonString);

    setState(() {
      dropdownOptions = List<String>.from(jsonData[widget.jsonFileOption]);
      dropdownValue = (dropdownOptions.isNotEmpty ? dropdownOptions[0] : null)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 18.0),
      child: DropdownButtonFormField<String>(
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
            borderSide: BorderSide(
              color: Colors.blueAccent,
              width: 2.0,
            ),
          ),
        ),
        value: dropdownValue,
        icon: const Icon(Icons.arrow_drop_down),
        style: TextStyle(color: Colors.grey[600]!),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              dropdownValue = newValue;
            });
            widget.onValueChanged(newValue);
          }
        },
        items: dropdownOptions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
