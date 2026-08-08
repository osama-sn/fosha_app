class GovernorateModel {
  final String id;
  final String nameAr;
  final String nameEn;

  const GovernorateModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  String getName(String languageCode) {
    return languageCode == 'en' ? nameEn : nameAr;
  }
}

class AppGovernorates {
  AppGovernorates._();

  static const List<GovernorateModel> governorates = [
    GovernorateModel(id: 'cairo', nameAr: 'القاهرة', nameEn: 'Cairo'),
    GovernorateModel(id: 'giza', nameAr: 'الجيزة', nameEn: 'Giza'),
    GovernorateModel(id: 'alexandria', nameAr: 'الإسكندرية', nameEn: 'Alexandria'),
    GovernorateModel(id: 'qalyubia', nameAr: 'القليوبية', nameEn: 'Qalyubia'),
    GovernorateModel(id: 'port_said', nameAr: 'بورسعيد', nameEn: 'Port Said'),
    GovernorateModel(id: 'suez', nameAr: 'السويس', nameEn: 'Suez'),
    GovernorateModel(id: 'ismailia', nameAr: 'الإسماعيلية', nameEn: 'Ismailia'),
    GovernorateModel(id: 'dakahlia', nameAr: 'الدقهلية', nameEn: 'Dakahlia'),
    GovernorateModel(id: 'sharqia', nameAr: 'الشرقية', nameEn: 'Sharqia'),
    GovernorateModel(id: 'monufia', nameAr: 'المنوفية', nameEn: 'Monufia'),
    GovernorateModel(id: 'gharbia', nameAr: 'الغربية', nameEn: 'Gharbia'),
    GovernorateModel(id: 'kafr_el_sheikh', nameAr: 'كفر الشيخ', nameEn: 'Kafr El Sheikh'),
    GovernorateModel(id: 'damietta', nameAr: 'دمياط', nameEn: 'Damietta'),
    GovernorateModel(id: 'beheira', nameAr: 'البحيرة', nameEn: 'Beheira'),
    GovernorateModel(id: 'faiyum', nameAr: 'الفيوم', nameEn: 'Faiyum'),
    GovernorateModel(id: 'beni_suef', nameAr: 'بني سويف', nameEn: 'Beni Suef'),
    GovernorateModel(id: 'minya', nameAr: 'المنيا', nameEn: 'Minya'),
    GovernorateModel(id: 'asyut', nameAr: 'أسيوط', nameEn: 'Asyut'),
    GovernorateModel(id: 'sohag', nameAr: 'سوهاج', nameEn: 'Sohag'),
    GovernorateModel(id: 'qena', nameAr: 'قنا', nameEn: 'Qena'),
    GovernorateModel(id: 'luxor', nameAr: 'الأقصر', nameEn: 'Luxor'),
    GovernorateModel(id: 'aswan', nameAr: 'أسوان', nameEn: 'Aswan'),
    GovernorateModel(id: 'red_sea', nameAr: 'البحر الأحمر', nameEn: 'Red Sea'),
    GovernorateModel(id: 'south_sinai', nameAr: 'جنوب سيناء', nameEn: 'South Sinai'),
    GovernorateModel(id: 'north_sinai', nameAr: 'شمال سيناء', nameEn: 'North Sinai'),
    GovernorateModel(id: 'matrouh', nameAr: 'مطروح', nameEn: 'Matrouh'),
    GovernorateModel(id: 'new_valley', nameAr: 'الوادي الجديد', nameEn: 'New Valley'),
  ];

  static List<String> get arabicNames =>
      governorates.map((g) => g.nameAr).toList();

  static List<String> get englishNames =>
      governorates.map((g) => g.nameEn).toList();

  static List<String> getNames(String languageCode) =>
      languageCode == 'en' ? englishNames : arabicNames;

  static String? getArabicName(String? name) {
    if (name == null || name.trim().isEmpty) return null;
    final gov = governorates.firstWhere(
      (g) =>
          g.nameAr == name ||
          g.nameEn.toLowerCase() == name.toLowerCase() ||
          g.id == name,
      orElse: () => GovernorateModel(id: name, nameAr: name, nameEn: name),
    );
    return gov.nameAr;
  }

  static String? getEnglishName(String? name) {
    if (name == null || name.trim().isEmpty) return null;
    final gov = governorates.firstWhere(
      (g) =>
          g.nameAr == name ||
          g.nameEn.toLowerCase() == name.toLowerCase() ||
          g.id == name,
      orElse: () => GovernorateModel(id: name, nameAr: name, nameEn: name),
    );
    return gov.nameEn;
  }
}
