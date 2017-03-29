@TestOn('dartium')
import 'package:test/test.dart';
import 'dart:convert';
import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';

@reflectable
class S extends Object with JsonConverter {
  int fieldS;
}

@reflectable
class I extends S {
  int fieldI;
}

/**/
main() {
  group('test group', () {
    setUp(() {});

    test('some test', () {
      var i = new I();

      var jsonString = '{"fieldI":1,"fieldS":2}';

      var json = JSON.decode(jsonString);

      i.fromJson(json);

      expect(false, true);
    });
  });
}
