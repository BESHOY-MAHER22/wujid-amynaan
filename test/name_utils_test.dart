import 'package:flutter_test/flutter_test.dart';

import 'package:project/core/services/name_utils.dart';

void main() {
  test('normalizes tashkeel, hamza variants, and surrounding spaces', () {
    expect(normalizeName('  إِيرِينى  '), 'ايرينى');
  });

  test('classifies Coptic female names and female suffixes', () {
    expect(isFemaleName('مارفن'), isTrue);
    expect(isFemaleName('يوأنا'), isTrue);
    expect(isFemaleName('مارينا'), isTrue);
    expect(isFemaleName('اسم ة'), isTrue);
    expect(isFemaleName('اسماء'), isTrue);
  });

  test('male exceptions override female suffix rules', () {
    for (final name in [
      'مينا',
      'رضا',
      'زكريا',
      'إيليا',
      'ايليا',
      'يحيى',
      'عيسى',
      'موافي',
      'بشوي',
      'بيشوي',
    ]) {
      expect(isFemaleName(name), isFalse, reason: name);
    }
  });
}
