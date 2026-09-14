const _femaleNameTokens = [
  'ماريا',
  'مريم',
  'سارة',
  'فاطمة',
  'مروة',
  'إيمان',
  'آية',
  'داليا',
  'رنا',
  'ياسمين',
  'هبة',
  'رغدة',
  'هدى',
  'منال',
  'دينا',
  'أماني',
  'أمل',
  'ملاك',
  'سلمى',
  'مها',
  'حلا',
  'فادية',
  'لينا',
  'سالي',
  'آلاء',
  'ليلى',
  'نورا',
  'ميرا',
  'هند',
  'شهد',
  'يمنى',
  'غادة',
  'منى',
  'رانية',
  'سميرة',
  'أنا',
  'مارفن',
  'يوأنا',
  'مارينا',
  'مارتينا',
  'فيرونيكا',
  'دميانة',
  'ساندرا',
  'مونيكا',
  'يوستينا',
  'إيريني',
  'إيرينى',
  'ميرنا',
  'كارولين',
  'كريستين',
  'شرين',
  'شيرين',
  'تيريزا',
  'فبرونيا',
  'سيلفيا',
  'جوستينا',
  'بيبو',
  'نيفين',
  'سوزان',
  'ميرفت',
  'جوانا',
  'كلير',
];

const _maleNameExceptions = [
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
];

String normalizeName(String input) {
  return input
      .replaceAll(RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED]'), '')
      .replaceAll(RegExp(r'[أإآ]'), 'ا')
      .trim();
}

bool isFemaleName(String name) {
  final normalized = normalizeName(name);
  if (normalized.isEmpty) return false;

  final compactName = normalized.replaceAll(RegExp(r'\s+|-'), '');
  final maleException = _maleNameExceptions.any(
    (maleName) => normalizeName(maleName) == compactName,
  );
  if (maleException) return false;

  final matchesKnownName = _femaleNameTokens.any(
    (femaleName) => compactName.contains(normalizeName(femaleName)),
  );
  if (matchesKnownName) return true;

  return compactName.endsWith('ة') ||
      compactName.endsWith('ه') ||
      compactName.endsWith('ى') ||
      compactName.endsWith('اء') ||
      compactName.endsWith('ا');
}

bool isBishopAthanasius(String input) {
  final normalized = normalizeName(input).replaceAll('ة', 'ه').toLowerCase();

  return normalized.contains('اثناسيوس') || normalized.contains('athanasius');
}
