import 'package:flutter/material.dart';
import 'package:lovelace/utils/colors.dart';

class DisplayCard extends StatefulWidget {
  final dynamic image;
  final String name;
  final int age;
  final String location;
  final double extraWidth;

  const DisplayCard(
      {super.key,
      required this.image,
      required this.name,
      required this.age,
      required this.location,
      this.extraWidth = 0});

  @override
  State<DisplayCard> createState() => _DisplayCardState();
}

class _DisplayCardState extends State<DisplayCard> {
  _DisplayCardState();

  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    final double screenWidth = queryData.size.width;
    final double screenHeight = queryData.size.height;
    final double cardWidth = screenWidth / 1.23;
    // dynamic image;
    // bool isImage;
    // ClipRRect cardImage() {
    //   return null;
    // }
    // if (widget.image.runtimeType == String) {
    //   image = Image.asset(
    //     widget.image,
    //     height: cardWidth / 2 * 3,
    //     width: cardWidth,
    //     fit: BoxFit.cover,
    //   );
    // } else if (widget.image.runtimeType == File) {
    //   image = Image.file(
    //     widget.image,
    //     height: cardWidth / 2 * 3,
    //     width: cardWidth,
    //     fit: BoxFit.cover,
    //   );
    // } else {
    //   image = Container(
    //     // width: 100,
    //     // height: 100,
    //     decoration: BoxDecoration(
    //       // border: Border.all(color: Colors.grey.shade300),
    //       // shape: BoxShape.circle,
    //       image: DecorationImage(fit: BoxFit.cover, image: widget.image),
    //     ),
    //   );
    // }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        // cardImage(),
        // ClipRRect(
        //     borderRadius: BorderRadius.circular(25), child: isImage ? "" : ""),
        Container(
          height: cardWidth / 2 * 3,
          width: cardWidth,
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: widget.image.runtimeType != String
                    ? widget.image
                    : Image.asset(widget.image).image),
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
                    widget.name,
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
                    "${widget.age} • ${widget.location}",
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
