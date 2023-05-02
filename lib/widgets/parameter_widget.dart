import 'package:flutter/material.dart';
import 'package:parameter_page/dpm_service.dart';
import 'package:parameter_page/widgets/page_entry_widget.dart';

import 'data_acquisition_widget.dart';

class ParameterWidget extends StatelessWidget {
  final String drf;
  final String? label;
  final bool editMode;
  final bool wide;

  const ParameterWidget(this.drf, this.editMode, this.wide,
      {this.label, super.key});

  Widget buildEditor(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 36.0),
        child: Text(overflow: TextOverflow.ellipsis, drf));
  }

  @override
  Widget build(BuildContext context) {
    return PageEntryWidget(
        child: editMode
            ? buildEditor(context)
            : _ActiveParamWidget(
                drf: drf, wide: wide, dpm: DataAcquisitionWidget.of(context)));
  }
}

class _ActiveParamWidget extends StatefulWidget {
  final String drf;
  final DataAcquisitionWidget dpm;
  final bool wide;

  const _ActiveParamWidget(
      {required this.drf, required this.dpm, required this.wide});

  @override
  _ActiveParamState createState() => _ActiveParamState();
}

class _ActiveParamState extends State<_ActiveParamWidget> {
  late final Future<List<DeviceInfo>> _setup;
  late final Stream<Reading> _stream;
  String? description;
  String? units;

  @override
  void initState() {
    _setup = widget.dpm.getDeviceInfo([widget.drf]);
    _stream = widget.dpm.monitorDevices([widget.drf]);
    super.initState();
  }

  Widget _buildParam(double? value, String? units, {required Key key}) {
    return value == null
        ? Container()
        : (units == null
            ? Text(textAlign: TextAlign.end, value.toStringAsPrecision(4))
            : Row(children: [
                Text(textAlign: TextAlign.end, value.toStringAsPrecision(4)),
                const SizedBox(width: 6.0),
                Text(units, style: const TextStyle(color: Colors.grey))
              ]));
  }

  Widget _buildWide(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 34.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 3,
                child: Tooltip(
                    message: widget.drf,
                    child: Text(overflow: TextOverflow.ellipsis, widget.drf))),
            Expanded(
                flex: 2,
                child:
                    Text(overflow: TextOverflow.ellipsis, description ?? "")),
            const Spacer(),
            Row(
              children: [
                _buildParam(50.0, "mm",
                    key: Key("parameter_setting_${widget.drf}")),
                const SizedBox(width: 12.0),
                StreamBuilder(
                    stream: _stream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        return _buildParam(snapshot.data!.value, units,
                            key: Key("parameter_reading_${widget.drf}"));
                      } else {
                        return _buildParam(null, units,
                            key: Key("parameter_nullreading_${widget.drf}"));
                      }
                    })
              ],
            ),
          ],
        ));
  }

  Widget _buildNarrow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Tooltip(
            message: widget.drf,
            child: Text(overflow: TextOverflow.ellipsis, widget.drf)),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
              overflow: TextOverflow.ellipsis,
              description ?? "",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontStyle: FontStyle.italic, color: Colors.grey)),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _buildParam(50.0, units, key: Key("parameter_setting_${widget.drf}")),
          StreamBuilder(
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  return _buildParam(snapshot.data!.value, units,
                      key: Key("parameter_reading_${widget.drf}"));
                } else {
                  return _buildParam(null, units,
                      key: Key("parameter_nullreading_${widget.drf}"));
                }
              })
        ]),
      ]),
    );
  }

  // Builds the widget.

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // The FUtureBuilder monitors our `getDeviceInfo` query. When it
      // completes, we transfer over the values of `description` and `units` so
      // the widgets can display them.

      future: _setup.then((value) {
        description = value.first.description;
        units = value.first.units;
        return value;
      }),

      // The builder function decides which renderer to call.

      builder: (context, snapshot) {
        return widget.wide ? _buildWide(context) : _buildNarrow(context);
      },
    );
  }
}