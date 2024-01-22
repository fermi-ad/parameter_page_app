import 'package:flutter/material.dart';

enum PagePersistenceState { clean, unsaved, saving, saved, unsavedError }

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
        return _buildUnsaved(context);

      case PagePersistenceState.saving:
        return _buildSaving(context);

      case PagePersistenceState.saved:
        return _buildSaved(context);

      case PagePersistenceState.unsavedError:
        return _buildUnsavedError(context);
    }
  }

  Widget _buildSaved(BuildContext context) {
    return Text(
        key: const Key("page_saved_indicator"),
        "Saved",
        style: TextStyle(
            fontSize: 12.0, color: Theme.of(context).colorScheme.secondary));
  }

  Widget _buildSaving(BuildContext context) {
    return Text(
        key: const Key("page_saving_indicator"),
        "Saving...",
        style: TextStyle(
            fontSize: 12.0, color: Theme.of(context).colorScheme.secondary));
  }

  Widget _buildUnsaved(BuildContext context) {
    return Row(children: [
      Tooltip(
          key: const Key("unsaved_changes_indicator"),
          message: "This page has unsaved changes.",
          child: Icon(Icons.warning,
              color: Theme.of(context).colorScheme.tertiary))
    ]);
  }

  Widget _buildUnsavedError(BuildContext context) {
    return Row(children: [
      Tooltip(
          key: const Key("page_save_failed_indicator"),
          message:
              "This page has unsaved changes.  The last attempt to save this page failed.  Please try again.",
          child:
              Icon(Icons.warning, color: Theme.of(context).colorScheme.error))
    ]);
  }
}
