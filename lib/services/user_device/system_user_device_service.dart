import 'package:flutter/services.dart';
import 'package:parameter_page/services/user_device/user_device_service.dart';

class SystemUserDeviceService extends UserDeviceService {
  @override
  Future<dynamic> getClipboard() async {
    return Clipboard.getData(Clipboard.kTextPlain);
  }

  @override
  setClipboard({required String to}) {
    Clipboard.setData(ClipboardData(text: to));
  }
}
