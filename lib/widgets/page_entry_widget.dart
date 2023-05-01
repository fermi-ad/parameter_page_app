import 'package:flutter/widgets.dart';

class PageEntryWidget extends StatelessWidget {
  final Widget child;

  const PageEntryWidget({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0), child: child);
  }
}
