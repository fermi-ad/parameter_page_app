import 'package:parameter_page/services/user_device/user_device_service.dart';

class MockUserDeviceService extends UserDeviceService {
  String clipboardText = "";

  @override
  Future<dynamic> getClipboard() async {
    return clipboardText;
  }

  @override
  setClipboard({required String to}) {
    clipboardText = to;
  }
}
