import 'package:flutter/material.dart';
import 'package:parameter_page/dpm_service.dart';

class Util {
  static Color mapColor({required StatusColor from}) {
    switch (from) {
      case StatusColor.black:
        return Colors.black;
      case StatusColor.blue:
        return Colors.blue;
      case StatusColor.cyan:
        return Colors.cyan;
      case StatusColor.green:
        return Colors.green;
      case StatusColor.magenta:
        return Colors.pink;
      case StatusColor.red:
        return Colors.red;
      case StatusColor.white:
        return Colors.white;
      case StatusColor.yellow:
        return Colors.yellow;
    }
  }
}
