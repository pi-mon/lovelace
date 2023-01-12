import 'package:flutter/material.dart';
import 'package:lovelace/utils/colors.dart';

class AccountButton extends StatelessWidget {
  final String label;
  final dynamic nextScreen;
  const AccountButton(
      {super.key, required this.label, required this.nextScreen});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => nextScreen()));
          },
          style: ElevatedButton.styleFrom(backgroundColor: whiteColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(label, style: TextStyle(fontSize: 17, color: blackColor)),
              Icon(Icons.arrow_right, color: placeholderColor)
            ],
          ),
        ));
  }
}
