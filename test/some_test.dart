@TestOn('dartium')
import 'package:test/test.dart';

class InjectableService {
  bool someMethod() {
    return false;
  }
}


/**/
main() {


  group('test group', () {

    setUp(() {

    });

    test('some test', () {

      expect(false, true);
    });
  });
}
