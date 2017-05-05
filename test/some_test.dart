@TestOn('dartium')
import 'package:test/test.dart';
import 'dart:convert';
import 'package:converters/json_converter.dart';
import 'package:converters/map_converter.dart';
import 'package:converters/reflector.dart';

@reflectable
class TestClass extends Object with JsonConverter {
  int intField;
  double doubleField;
  DateTime dateTimeField;
}

/**/
main() {
  group('converting', () {
    setUp(() {});

    test('convert to DateTime (full)', () {
      var testClass = new TestClass();

      testClass.intField = 100;
      testClass.doubleField = 100.95;
      testClass.dateTimeField =
          new DateTime.utc(2017, 12, 31, 23, 59, 58, 100, 200);

      var jsonString = testClass.toJsonString();

      print('full test: ' + jsonString);

      expect(true, true);
    });

    test('convert to DateTime (short)', () {
      var testClass = new TestClass();

      testClass.intField = 100;
      testClass.doubleField = 100.95;
      testClass.dateTimeField = new DateTime.utc(2017, 12, 31);

      var jsonString = testClass.toJsonString();

      print('short test: ' + jsonString);

      expect(true, true);
    });

    test('convert from DateTime (full)', () {
      var str =
          '{"intField":100,"doubleField":100.95,"dateTimeField":"2017-12-31T23:59:58.100200Z"}';

      TestClass testClass = new TestClass().fromJsonString(str);

      DateTime expectedDt =
          new DateTime.utc(2017, 12, 31, 23, 59, 58, 100, 200);

      expect(testClass.dateTimeField.year, expectedDt.year);
      expect(testClass.dateTimeField.month, expectedDt.month);
      expect(testClass.dateTimeField.day, expectedDt.day);
      expect(testClass.dateTimeField.hour, expectedDt.hour);
      expect(testClass.dateTimeField.minute, expectedDt.minute);
      expect(testClass.dateTimeField.second, expectedDt.second);
      expect(testClass.dateTimeField.millisecond, expectedDt.millisecond);
      expect(testClass.dateTimeField.microsecond, expectedDt.microsecond);
    });

    test('convert from DateTime (short)', () {
      var str =
          '{"intField":100,"doubleField":100.95,"dateTimeField":"2017-12-31T00:00:00.000Z"}';

      TestClass testClass = new TestClass().fromJsonString(str);

      DateTime expectedDt = new DateTime.utc(2017, 12, 31);

      expect(testClass.dateTimeField.year, expectedDt.year);
      expect(testClass.dateTimeField.month, expectedDt.month);
      expect(testClass.dateTimeField.day, expectedDt.day);
    });

    test('convert from DateTime (timezone)', () {
      var str =
          '{"intField":100,"doubleField":100.95,"dateTimeField":"2017-12-31T12:31:02.680Z"}';

      TestClass testClass = new TestClass().fromJsonString(str);

      DateTime expectedDt = new DateTime.utc(2017, 12, 31, 15, 31, 02);

      expect(testClass.dateTimeField.year, expectedDt.year);
      expect(testClass.dateTimeField.month, expectedDt.month);
      expect(testClass.dateTimeField.day, expectedDt.day);
      expect(testClass.dateTimeField.hour, expectedDt.hour);
      expect(testClass.dateTimeField.minute, expectedDt.minute);
      expect(testClass.dateTimeField.second, expectedDt.second);
      expect(testClass.dateTimeField.timeZoneOffset.inHours, 0);
      expect(testClass.dateTimeField.isUtc, true);
    });
  });
}
