import 'package:flutter_test/flutter_test.dart';
import 'package:growapp/data/services/api_client.dart';

void main() {
  group('ApiException', () {
    test('toString includes statusCode and title', () {
      const e = ApiException(statusCode: 429, title: 'Too many requests');
      expect(e.toString(), contains('429'));
      expect(e.toString(), contains('Too many requests'));
    });

    test('toString includes detail when present', () {
      const e = ApiException(
        statusCode: 400,
        title: 'Bad Request',
        detail: 'Invalid field',
      );
      expect(e.toString(), contains('Invalid field'));
    });

    test('toString omits detail when null', () {
      const e = ApiException(statusCode: 500, title: 'Server Error');
      expect(e.toString(), isNot(contains('null')));
    });
  });
}
