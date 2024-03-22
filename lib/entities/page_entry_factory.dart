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

  List<PageEntry> _findAllTheParameterEntries({required String inside}) {
    List<String> textArr = inside.split(" ");
    List<PageEntry> ret = [];

    for (String textElement in textArr) {
      if (_isACNETDRF(textElement) || _isProcessVariable(textElement)) {
        ret.add(ParameterEntry(textElement, label: ""));
      }
    }

    return ret;
  }

  bool _isACNETDRF(String val) {
    return _drfRegEx.hasMatch(val);
  }

  bool _isProcessVariable(String val) {
    return _pvRegEx.hasMatch(val);
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

  final _drfRegEx = RegExp(r"^[A-Za-z][:_|][A-Za-z0-9@,]{1,255}$");

  final _pvRegEx = RegExp(r"^([A-Za-z0-9:_]{1,255}):([A-Za-z0-9:_]{1,255})$");

  final _multRegExp = RegExp(
      r"^mult:(?<numberOfEntries>\d)\s?(?<description>.*)?",
      caseSensitive: false);
}
