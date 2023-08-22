import 'package:flutter/material.dart';
import 'package:parameter_page/widgets/page_persistence_state_indicator_widget.dart';

class PageTitleWidget extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  final String title;

  final bool editing;

  final PagePersistenceState persistenceState;

  final Function(String) onTitleUpdate;

  PageTitleWidget(
      {super.key,
      required this.title,
      required this.editing,
      required this.persistenceState,
      required this.onTitleUpdate}) {
    controller.text = title;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        key: const Key("page_title"),
        child: editing ? _buildEditor() : _buildReadOnly());
  }

  Widget _buildReadOnly() {
    return Row(children: [
      Text(title),
      const SizedBox(width: 8.0),
      PagePersistenceStateIndicatorWidget(persistenceState: persistenceState)
    ]);
  }

  Widget _buildEditor() {
    return Row(children: [
      Expanded(
          child: TextField(
        key: const Key("page_title_textfield"),
        maxLines: 1,
        minLines: 1,
        controller: controller,
        onTapOutside: (PointerDownEvent event) =>
            onTitleUpdate.call(controller.text),
      ))
    ]);
  }
}
