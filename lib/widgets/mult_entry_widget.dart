import 'package:flutter/material.dart';
import 'package:parameter_page/widgets/page_entry_widget.dart';

class MultEntryWidget extends StatefulWidget {
  final int numberOfEntries;

  final String description;

  final bool editMode;

  const MultEntryWidget(
      {super.key,
      required this.numberOfEntries,
      this.description = "",
      this.editMode = false});

  @override
  State<StatefulWidget> createState() {
    return _MultEntryWidgetState();
  }
}

class _MultEntryWidgetState extends State<MultEntryWidget> {
  @override
  Widget build(BuildContext context) {
    return PageEntryWidget(
        child: widget.editMode ? _buildEditMode() : _buildDisplayMode());
  }

  Widget _buildEditMode() {
    return ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 36.0),
        child: _buildEntryText());
  }

  Widget _buildDisplayMode() {
    return InkWell(
        onTap: _handleTap,
        child: Card(
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: _active
                        ? _colorScheme.secondaryContainer
                        : _colorScheme.surface,
                    width: 2.0),
                borderRadius: BorderRadius.circular(4.0)),
            child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 34.0),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 40.0),
                    child: _buildEntryText()))));
  }

  Widget _buildEntryText() {
    return Text("mult:${widget.numberOfEntries} ${widget.description}",
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: _colorScheme.secondary));
  }

  void _handleTap() => setState(() => _active = !_active);

  ColorScheme get _colorScheme => Theme.of(context).colorScheme;

  bool _active = false;
}
