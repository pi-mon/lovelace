import 'package:flutter/material.dart';
import 'package:lovelace/utils/colors.dart';

class WideButtonArrow extends StatelessWidget {
  final IconData iconData;
  final String label;
  final Color labelColor;
  final dynamic nextScreen;
  final bool isAdmin;
  const WideButtonArrow(
      {super.key,
      required this.iconData,
      required this.label,
      this.labelColor = blackColor,
      required this.nextScreen,
      this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            if (!isAdmin) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => nextScreen));
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => nextScreen),
                  (route) => false);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: whiteColor),
          child: Row(children: <Widget>[
            Icon(iconData, color: placeholderColor),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, color: labelColor),
            )
          ]),
          // style: ElevatedButton.styleFrom(backgroundColor: whiteColor),
          // child: Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: <Widget>[
          //     Row(
          //       children: [
          //         icon,
          //         Text(label,
          //             style: TextStyle(fontSize: 17, color: blackColor)),
          //       ],
          //     ),
          //     Icon(Icons.arrow_right, color: placeholderColor)
          //   ],
          // ),
        ));
  }
}
