import 'package:flutter/material.dart';

class SubPageNavigationWidget extends StatelessWidget {
  const SubPageNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        key: const Key("subpagenavigation-current-subpage"),
        child: const Text("2"));
  }
}
