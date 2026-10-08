import 'package:test/test.dart';
import 'package:youtube_explode_dart/src/extensions/helpers_extension.dart';

void main() {
  Duration? age(String? text) {
    final date = text.toDateTime();
    return date == null ? null : DateTime.now().difference(date);
  }

  void expectAge(String text, Duration expected) {
    final actual = age(text);
    expect(actual, isNotNull, reason: text);
    expect((actual! - expected).inSeconds.abs(), lessThan(5), reason: text);
  }

  group('Short relative dates (current YouTube format)', () {
    test('years, months, weeks, days, hours', () {
      expectAge('3y ago', const Duration(days: 3 * 365));
      expectAge('2mo ago', const Duration(days: 60));
      expectAge('1w ago', const Duration(days: 7));
      expectAge('5d ago', const Duration(days: 5));
      expectAge('4h ago', const Duration(hours: 4));
    });

    test('minutes and seconds', () {
      expectAge('10m ago', const Duration(minutes: 10));
      expectAge('10min ago', const Duration(minutes: 10));
      expectAge('30s ago', const Duration(seconds: 30));
    });

    test('past live streams', () {
      expectAge('Streamed 1y ago', const Duration(days: 365));
      expectAge('Streamed 3d ago', const Duration(days: 3));
    });
  });

  group('Long relative dates', () {
    test('plain and streamed', () {
      expectAge('5 years ago', const Duration(days: 5 * 365));
      expectAge('1 month ago', const Duration(days: 30));
      expectAge('Streamed 2 days ago', const Duration(days: 2));
      expectAge('3 hours ago', const Duration(hours: 3));
    });
  });

  group('Anything else is null, never an exception', () {
    for (final text in [
      null,
      '',
      'Premiered Oct 2, 2024',
      'Scheduled for 10/10/26',
      'Streamed live',
      '3 lightyears ago',
    ]) {
      test('"$text"', () {
        expect(() => text.toDateTime(), returnsNormally);
        expect(text.toDateTime(), isNull);
      });
    }
  });
}
