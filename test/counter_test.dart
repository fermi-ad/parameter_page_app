// Unit tests for Counter

import 'package:parameter_page/counter.dart';
import 'package:test/test.dart';

void main() {
  test("increment(), adds one to the counter", () {
    // Given a counter initialized to 0
    final counter = Counter();
    expect(counter.value, 0);

    // When I increment()
    counter.increment();

    // Then the counter is 1
    expect(counter.value, 1);
  });
}
