import 'package:flutter/widgets.dart';
import 'package:parameter_page/dpm_service.dart';

class DataAcquisitionWidget extends InheritedWidget {
  final DpmService service;

  const DataAcquisitionWidget(
      {super.key, required super.child, required this.service});

  Future<List<DeviceInfo>> getDeviceInfo(List<String> devices) {
    return service.getDeviceInfo(devices);
  }

  Stream<Reading> monitorDevices(List<String> drfs) {
    return service.monitorDevices(drfs);
  }

  // This should return `true` if the state of widget has changed. Since it only
  // provides access to GraphQL, nothing ever changes so we always return
  // `false`.

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  // These static functions provide access to this widget from down the widget
  // chain.

  static DataAcquisitionWidget? _maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DataAcquisitionWidget>();
  }

  static DataAcquisitionWidget of(BuildContext context) {
    final DataAcquisitionWidget? result = _maybeOf(context);

    assert(result != null, 'no DataAcquisitionWidget found in context');
    return result!;
  }
}
