import 'package:flutter_controls_core/service/acsys/service.dart';
import 'package:test/test.dart';

void main() {
  group('monitorAlarm', () {
    test("monitorAlarm for G:AMANDA, get some alarm status back", () async {
      // Given an AcsysServiceAPI
      final service = ACSysService();

      // When I monitorAnalogAlarm for G:AMANDA
      final stream = service.monitorAnalogAlarmProperty(["G:AMANDA"]);
      final reading = await stream.first;

      // Then I receive some status back
      print("$reading");
    });
  });
}
