import 'package:flutter/material.dart';
import 'package:lovelace/utils/colors.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String label;
  final String hintText;
  final String error;
  final TextInputType textInputType;
  const TextFieldInput(
      {super.key,
      required this.textEditingController,
      this.isPass = false,
      required this.label,
      required this.hintText,
      this.error = "",
      required this.textInputType, required String? Function(dynamic value) validator});

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context, color: borderColor),
    );
    return Column(
      children: <Widget>[
        Row(children: <Widget>[
            Text(
              label,
              // ignore: prefer_const_constructors
              style: TextStyle(
                color: primaryColor,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: textEditingController,
          decoration: InputDecoration(
            hintText: hintText,
            border: inputBorder,
            focusedBorder: inputBorder,
            enabledBorder: inputBorder,
            filled: true,
            contentPadding: const EdgeInsets.all(8),
          ),
          keyboardType: textInputType,
          obscureText: isPass,
          validator: (value) { // validate user input          
            if (value == null || value.isEmpty) {
              return "Invalid Input!"; // return error message
            }             
            return null; 
          },
        ),
        const SizedBox(height: 8),
        Row(children: <Widget>[
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
