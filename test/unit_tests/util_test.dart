import 'package:parameter_page/widgets/util.dart';
import 'package:test/test.dart';

void main() {
  group('Util.toSettingDRFs(from:) unit tests', () {
    test("Single ACNET device with colon, replace with _", () {
      // Given an ACNET device called G:AMANDA
      // When I call toSettingDRFs...
      var drfs = Util.toSettingDRFs(from: ["G:AMANDA"]);

      // Then the second character is replaced with a _
      expect(drfs.contains("G_AMANDA"), true);
    });
  });
}
