import 'package:flutter/material.dart';

class CommandButtonWidget extends StatefulWidget {
  final String drf;

  final int value;

  final String longName;

  const CommandButtonWidget(
      {super.key,
      required this.drf,
      required this.value,
      required this.longName});

  @override
  State<StatefulWidget> createState() {
    return _CommandButtonState();
  }
}

class _CommandButtonState extends State<CommandButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () {}, child: Text(widget.longName));
  }
}
