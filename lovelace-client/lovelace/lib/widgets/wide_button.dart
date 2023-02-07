import 'package:flutter/material.dart';
import 'package:lovelace/utils/colors.dart';

class WideButton extends StatelessWidget {
  final String label;
  final Icon icon;
  final Color labelColor;
  final VoidCallback? onPressed;
  const WideButton(
      {super.key,
      required this.icon,
      required this.label,
      this.labelColor = blackColor,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: onPressed,
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
