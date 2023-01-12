import 'package:flutter/material.dart';
import 'package:lovelace/utils/colors.dart';

class DropdownFieldInput extends StatelessWidget {
  final dynamic setState;
  final TextEditingController textEditingController;
  final List<String> dropdownValues;
  final String label;
  final String hintText;
  final String error;
  const DropdownFieldInput({
    super.key,
    this.setState,
    required this.textEditingController,
    required this.dropdownValues,
    required this.label,
    required this.hintText,
    this.error = "",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                color: primaryColor,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: .5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: DropdownButton<String>(
              iconEnabledColor: primaryColor,
              hint: Text(hintText),
              value: textEditingController.text,
              icon: const Icon(Icons.arrow_drop_down),
              isExpanded: true,
              underline: const SizedBox(),
              items: dropdownValues.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  textEditingController.text = newValue!;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Text(
              error,
              style: TextStyle(
                color: errorColor.withOpacity(1),
                fontSize: 14,
              ),
            ),
          ],
        )
      ],
    );
  }
}
