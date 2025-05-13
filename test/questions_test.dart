// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:survey_app/questions.dart';

void main() {
  group('isExclusive()', () {
    test('Valid, exclusive IDs', () {
      Question q;
      q = Question(id: '11-a', text: '', options: {});
      expect(q.isExclusive(), isTrue);
      q = Question(id: '42-b', text: '', options: {});
      expect(q.isExclusive(), isTrue);
      q = Question(id: '100-z', text: '', options: {});
      expect(q.isExclusive(), isTrue);
    });

    test('Valid, non-exclusive IDs', () {
      Question q;
      q = Question(id: '42', text: '', options: {});
      expect(q.isExclusive(), isFalse);
      q = Question(id: '100-8', text: '', options: {});
      expect(q.isExclusive(), isFalse);
      q = Question(id: '100-24', text: '', options: {});
      expect(q.isExclusive(), isFalse);
    });

    test('Invalid IDs', () {
      Question q;
      q = Question(id: '42-ab1', text: '', options: {});
      expect(q.isExclusive(), isFalse);
      q = Question(id: '100-1a', text: '', options: {});
      expect(q.isExclusive(), isFalse);
    });
  });

  group('isSublist()', () {
    test('Valid, sublist IDs', () {
      Question q;
      q = Question(id: '6-1', text: '', options: {});
      expect(q.isSublist(), isTrue);
      q = Question(id: '100-8', text: '', options: {});
      expect(q.isSublist(), isTrue);
      q = Question(id: '100-24', text: '', options: {});
      expect(q.isSublist(), isTrue);
    });

    test('Valid, non-sublist IDs', () {
      Question q;
      q = Question(id: '11-a', text: '', options: {});
      expect(q.isSublist(), isFalse);
      q = Question(id: '42-b', text: '', options: {});
      expect(q.isSublist(), isFalse);
      q = Question(id: '100-z', text: '', options: {});
      expect(q.isSublist(), isFalse);
    });

    test('Invalid IDs', () {
      Question q;
      q = Question(id: '42-ab1', text: '', options: {});
      expect(q.isSublist(), isFalse);
      q = Question(id: '100-1a', text: '', options: {});
      expect(q.isSublist(), isFalse);
    });
  });

  group('getMajorNumber()', () {
    test('Valid, major numbers only', () {
      Question q;
      q = Question(id: '42', text: '', options: {});
      expect(q.getMajorNumber(), equals(42));
      q = Question(id: '100', text: '', options: {});
      expect(q.getMajorNumber(), equals(100));
    });

    test('Valid, numeric minor question numbers', () {
      Question q;
      q = Question(id: '42-7', text: '', options: {});
      expect(q.getMajorNumber(), equals(42));
      q = Question(id: '100-24', text: '', options: {});
      expect(q.getMajorNumber(), equals(100));
    });

    test('Valid, alphabetic minor question numbers', () {
      Question q;
      q = Question(id: '42-s', text: '', options: {});
      expect(q.getMajorNumber(), equals(42));
      q = Question(id: '100-hj', text: '', options: {});
      expect(q.getMajorNumber(), equals(100));
    });
  });
}
