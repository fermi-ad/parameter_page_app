import 'package:flutter/material.dart';
import 'package:parameter_page/widgets/data_acquisition_widget.dart';

class ParameterBeamInhibitStatusWidget extends StatelessWidget {
  final String drf;

  final BeamInhibitState state;

  const ParameterBeamInhibitStatusWidget(
      {super.key, required this.drf, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
        key: Key("parameter_digitalalarm_beaminhibit_$drf"),
        child: _buildIndicator(context));
  }

  Widget _buildIndicator(BuildContext context) {
    switch (state) {
      case BeamInhibitState.wontInhibit:
        return Tooltip(
            message: "Does not inhibit beam",
            child: Icon(Icons.pan_tool,
                size: 16, color: Theme.of(context).colorScheme.background));

      case BeamInhibitState.willInhibit:
        return Tooltip(
            message: "Will inhibit beam",
            child: Icon(Icons.pan_tool,
                size: 16, color: Theme.of(context).colorScheme.primary));

      case BeamInhibitState.byPassed:
        return Tooltip(
            message: "Beam inhibit by-passed",
            child: Icon(Icons.do_not_touch,
                size: 16, color: Theme.of(context).colorScheme.primary));
    }
  }
}
