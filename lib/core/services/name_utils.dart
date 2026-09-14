bool isBishopAthanasius(String input) {
  final normalized = input
      .replaceAll(RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED]'), '')
      .replaceAll(RegExp(r'[أإآ]'), 'ا')
      .replaceAll('ة', 'ه')
      .toLowerCase();

  return normalized.contains('اثناسيوس') || normalized.contains('athanasius');
}
