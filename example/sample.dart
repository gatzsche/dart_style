import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

main() {
  test('test', () {
    try {
      throw (AssertionError('Hello'));
    } on Object catch (error) {
      expect(error is AssertionError, true);
    }

    expect(() {
      throw (AssertionError('Hello'));
    }, throwsA(isA<AssertionError>()));
  });
}
