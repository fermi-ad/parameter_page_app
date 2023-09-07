import 'package:flutter/material.dart';

class ErrorDisplayWidget extends StatelessWidget {
  final String errorMessage;

  final String detailMessage;

  const ErrorDisplayWidget(
      {super.key, required this.errorMessage, required this.detailMessage});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Spacer(),
      Column(children: [
        const Spacer(),
        const Icon(Icons.warning),
        const SizedBox(height: 16),
        Text(errorMessage),
        Text("($detailMessage)"),
        const Spacer()
      ]),
      const Spacer()
    ]);
  }
}
