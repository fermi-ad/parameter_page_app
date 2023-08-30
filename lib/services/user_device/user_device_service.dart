abstract class UserDeviceService {
  Future<dynamic> getClipboard();

  setClipboard({required String to});
}
