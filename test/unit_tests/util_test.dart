import 'package:parameter_page/widgets/util.dart';
import 'package:test/test.dart';

void main() {
  group('Util.toSettingDRFs(from:) unit tests', () {
    void assertToSettingDRFs(
        {required List<String> input, required List<String> output}) {
      // Given an ACNET device called G:AMANDA
      // When I call toSettingDRFs...
      var drfs = Util.toSettingDRFs(from: input);

      // Then the second character is replaced with a _
      for (String expected in output) {
        expect(drfs.contains(expected), true);
      }
    }

    test("ACNET device with colon, replace with _", () {
      assertToSettingDRFs(
          input: ["G:AMANDA", "I:BEAM", "Z:BTE200_TEMP"],
          output: ["G_AMANDA", "I_BEAM", "Z_BTE200_TEMP"]);
    });
  });
}
