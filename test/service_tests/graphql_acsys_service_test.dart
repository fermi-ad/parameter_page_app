import 'package:flutter_controls_core/service/acsys/service.dart';
import 'package:test/test.dart';

void main() {
  group('getDeviceInfo', () {
    test('getDeviceInfo for G:AMANDA, description is returned', () async {
      // Given an ACSysService
      final service = ACSysService();

      // When I getDeviceInfo for G:AMANDA
      final results = await service.getDeviceInfo(["G:AMANDA"]);

      // Then an analog alarm block is returned
      expect(results[0].description, "Amanda catchall alarm!!!");
    });

    test('getDeviceInfo for G:AMANDA, reading property is returned', () async {
      // Given an ACSysService
      final service = ACSysService();

      // When I getDeviceInfo for G:AMANDA
      final results = await service.getDeviceInfo(["G:AMANDA"]);

      // Then an analog alarm block is returned
      expect(results[0].reading, isNotNull);
      expect(results[0].reading!.commonUnits, "oops");
      expect(results[0].reading!.primaryUnits, "oops");
    });

    test('getDeviceInfo for G:AMANDA, setting property is returned', () async {
      // Given an ACSysService
      final service = ACSysService();

      // When I getDeviceInfo for G:AMANDA
      final results = await service.getDeviceInfo(["G:AMANDA"]);

      // Then an analog alarm block is returned
      expect(results[0].reading, isNotNull);
      expect(results[0].reading!.commonUnits, "oops");
      expect(results[0].reading!.primaryUnits, "oops");
    });

    test('getDeviceInfo for G:AMANDA, digital control property is returned',
        () async {
      // Given an ACSysService
      final service = ACSysService();

      // When I getDeviceInfo for G:AMANDA
      final results = await service.getDeviceInfo(["G:AMANDA"]);

      // Then an analog alarm block is returned
      expect(results[0].digControl, isNotNull);
    });

    test('getDeviceInfo for G:AMANDA, basic status property is returned',
        () async {
      // Given an ACSysService
      final service = ACSysService();

      // When I getDeviceInfo for G:AMANDA
      final results = await service.getDeviceInfo(["G:AMANDA"]);

      // Then an analog alarm block is returned
      expect(results[0].basicStatus, isNotNull);
    });

    test('getDeviceInfo for G:AMANDA, extended status info is returned',
        () async {
      // Given an ACSysService
      final service = ACSysService();

      // When I getDeviceInfo for G:AMANDA
      final results = await service.getDeviceInfo(["G:AMANDA"]);

      // Then an analog alarm block is returned
      expect(results[0].basicStatus!.extendedBasicStatus, isNotNull);
    });

    test('getDeviceInfo for G:AMANDA, analog alarm block is present', () async {
      // Given an ACSysService
      final service = ACSysService();

      // When I getDeviceInfo for G:AMANDA
      final results = await service.getDeviceInfo(["G:AMANDA"]);

      // Then an analog alarm block is returned
      expect(results[0].alarm, isNotNull);
    });

    test('getDeviceInfo for G:AMANDA, digital alarm block is present',
        () async {
      // Given an ACSysService
      final service = ACSysService();

      // When I getDeviceInfo for G:AMANDA
      final results = await service.getDeviceInfo(["G:AMANDA"]);

      // Then an analog alarm block is returned
      expect(results[0].digitalAlarm, isNotNull);
    });
  });

  group('monitorAlarm', () {
    test("monitorAlarm for G:AMANDA, get not-alarming status back", () async {
      // Given an AcsysServiceAPI
      final service = ACSysService();

      // When I monitorAnalogAlarm for G:AMANDA
      final stream = service.monitorAnalogAlarmProperty(["G:AMANDA"]);
      final reading = await stream.first;

      // Then I receive a not alarming state
      expect(reading.state, AlarmState.notAlarming);
    });
  });
}
