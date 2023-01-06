import 'package:flutter/material.dart';
import 'package:lovelace/utils/colors.dart';

class DisplayCard extends StatefulWidget {
  final String name;
  final int age;
  final String location;
  final double extraWidth;

  const DisplayCard(
      {super.key,
      required this.name,
      required this.age,
      required this.location,
      this.extraWidth = 0});

  @override
  State<DisplayCard> createState() =>
      _DisplayCardState(name, age, location, extraWidth);
}

class _DisplayCardState extends State<DisplayCard> {
  _DisplayCardState(this.name, this.age, this.location, this.extraWidth);
  final String name;
  final int age;
  final String location;
  final double extraWidth;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    final double screenWidth = queryData.size.width;
    final double screenHeight = queryData.size.height;
    final double cardWidth = screenWidth / 1.23;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.asset(
            'assets/images/landing_user.jpeg',
            height: cardWidth / 2 * 3,
            width: cardWidth,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: cardWidth / 2 * 3,
          width: cardWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: const LinearGradient(
                colors: [
                  Colors.transparent,
                  Color.fromRGBO(26, 26, 26, .2),
                ],
                begin: FractionalOffset(0, 0),
                end: FractionalOffset(0, 1),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        Align(
          child: Container(
            padding: EdgeInsets.only(
                left: screenWidth / 23, bottom: screenHeight / 43),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: screenHeight / 19,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "$age • $location",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: screenHeight / 32,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
