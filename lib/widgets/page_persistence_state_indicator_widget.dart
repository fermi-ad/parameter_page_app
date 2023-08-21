import 'package:flutter/material.dart';

enum PagePersistenceState { clean, unsaved, saving, saved }

class PagePersistenceStateIndicatorWidget extends StatelessWidget {
  final PagePersistenceState persistenceState;

  const PagePersistenceStateIndicatorWidget(
      {super.key, required this.persistenceState});

  @override
  Widget build(BuildContext context) {
    switch (persistenceState) {
      case PagePersistenceState.clean:
        return Container();

      case PagePersistenceState.unsaved:
        return _buildUnsaved();

      case PagePersistenceState.saving:
        return _buildSaving();

      case PagePersistenceState.saved:
        return _buildSaved();
    }
  }

  Widget _buildSaved() {
    return const Text(
        key: Key("page_saved_indicator"),
        "Saved",
        style: TextStyle(fontSize: 12.0, color: Colors.grey));
  }

  Widget _buildSaving() {
    return const Text(
        key: Key("page_saving_indicator"),
        "Saving...",
        style: TextStyle(fontSize: 12.0, color: Colors.grey));
  }

  Widget _buildUnsaved() {
    return const Row(children: [
      Tooltip(
          key: Key("unsaved_changes_indicator"),
          message: "This page has unsaved changes.",
          child: Icon(Icons.warning, color: Colors.amber))
    ]);
  }
}
