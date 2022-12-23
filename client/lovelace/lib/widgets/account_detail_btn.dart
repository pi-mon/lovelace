import 'package:flutter/material.dart';

import '../utils/colors.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Icon icon;
  final Color labelColor;
  final VoidCallback? function;
  const CustomButton(
      {super.key,
      required this.icon,
      required this.label,
      required this.labelColor,
      required this.function});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: function,
            style: ElevatedButton.styleFrom(backgroundColor: whiteColor),
            child: Row(children: <Widget>[
              icon,
              const SizedBox(width: 10),
              Text(
                label,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: labelColor),
              )
            ]),
          )),
    );
  }
}
