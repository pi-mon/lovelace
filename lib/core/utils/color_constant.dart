import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  static Color black900 = fromHex('#000000');

  static Color bluegray400 = fromHex('#888888');

  static Color purpleA700 = fromHex('#8f00ff');

  static Color gray900 = fromHex('#1a1a1a');

  static Color purpleA200 = fromHex('#b04bff');

  static Color black9003f = fromHex('#3f000000');

  static Color whiteA700 = fromHex('#ffffff');

  static Color gray100 = fromHex('#f0f2f6');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
