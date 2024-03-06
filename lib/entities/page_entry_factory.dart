import 'package:flutter/material.dart';
import 'package:parameter_page/entities/page_entry.dart';

class PageEntryFactory {
  List<PageEntry> createEntries({required String fromInput}) {
    if (_isHardComment(fromInput)) {
      return [CommentEntry(_stripBang(fromInput))];
    } else if (_isMult(fromInput)) {
      return [_generateMultEntry(from: fromInput)];
    } else {
      final entries = _findAllTheParameterEntries(inside: fromInput);
      if (entries.isEmpty && fromInput.length > 1) {
        return [CommentEntry(fromInput)];
      } else {
        return entries;
      }
    }
  }

  bool isACNETDRF(String val) {
    var drfRegEx = RegExp(r"^[A-Za-z][:_|][A-Za-z0-9@,]{1,255}$");

    return drfRegEx.hasMatch(val);
  }

  bool isProcessVariable(String val) {
    var pvRegEx = RegExp(r"^([A-Za-z0-9:_]{1,255}):([A-Za-z0-9:_]{1,255})$");

    return pvRegEx.hasMatch(val);
  }

  List<PageEntry> _findAllTheParameterEntries({required String inside}) {
    List<String> textArr = inside.split(" ");
    List<PageEntry> ret = [];

    for (String textElement in textArr) {
      if (isACNETDRF(textElement) || isProcessVariable(textElement)) {
        ret.add(ParameterEntry(textElement,
            label: "", key: Key("parameter_row_$textElement")));
      }
    }

    return ret;
  }

  bool _isMult(String val) {
    return _multRegExp.hasMatch(val);
  }

  bool _isHardComment(String val) {
    return "!" == val[0];
  }

  String _stripBang(String textInput) {
    return textInput.substring(1);
  }

  MultEntry _generateMultEntry({required String from}) {
    final match = _multRegExp.firstMatch(from)!;
    int numberOfEntries =
        int.parse(match.namedGroup("numberOfEntries")!.toString());
    String description = match.namedGroup("description") ?? "";

    return MultEntry(
        numberOfEntries: numberOfEntries, description: description);
  }

  final _multRegExp = RegExp(
      r"^mult:(?<numberOfEntries>\d)\s?(?<description>.*)?",
      caseSensitive: false);
}
