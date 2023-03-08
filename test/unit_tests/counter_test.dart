// Unit tests for Counter

import 'package:parameter_page/counter.dart';
import 'package:test/test.dart';

void main() {
  test("increment(), adds one to the value", () {
    // Given a counter initialized to 0
    final counter = Counter();
    expect(counter.value, 0);

    // When I increment()
    counter.increment();

    // Then the counter is 1
    expect(counter.value, 1);
  });

  test("decrement(), reduces value by one", () {
    // Given a counter with a value of 1
    final counter = Counter();
    counter.increment();
    expect(counter.value, 1);

    // When I decrement()
    counter.decrement();

    // Then the counter is 0
    expect(counter.value, 0);
  });
}
