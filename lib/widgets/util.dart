import 'package:flutter/material.dart';
import 'package:flutter_controls_core/flutter_controls_core.dart';

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

  static List<String> toSettingDRFs({required List<String> from}) {
    List<String> ret = [];

    for (String drf in from) {
      ret.add(drf.replaceFirst(":", "_"));
    }

    return ret;
  }
}
