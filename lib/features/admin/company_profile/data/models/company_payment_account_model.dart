class CompanyPaymentAccountModel {
  final String id;
  final String provider;
  final String title;
  final String number;
  final String handle;
  final String accountHolder;
  final String bankName;
  final String iban;
  final String instructions;
  final bool isActive;

  const CompanyPaymentAccountModel({
    required this.id,
    required this.provider,
    required this.title,
    this.number = '',
    this.handle = '',
    this.accountHolder = '',
    this.bankName = '',
    this.iban = '',
    this.instructions = '',
    this.isActive = true,
  });

  factory CompanyPaymentAccountModel.fromJson(Map<String, dynamic> json) {
    return CompanyPaymentAccountModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      provider: json['provider'] as String? ?? 'wallet',
      title: json['title'] as String? ?? '',
      number: json['number'] as String? ?? '',
      handle: json['handle'] as String? ?? '',
      accountHolder: json['accountHolder'] as String? ?? '',
      bankName: json['bankName'] as String? ?? '',
      iban: json['iban'] as String? ?? '',
      instructions: json['instructions'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) '_id': id,
      'provider': provider,
      'title': title,
      if (number.isNotEmpty) 'number': number,
      if (handle.isNotEmpty) 'handle': handle,
      if (accountHolder.isNotEmpty) 'accountHolder': accountHolder,
      if (bankName.isNotEmpty) 'bankName': bankName,
      if (iban.isNotEmpty) 'iban': iban,
      if (instructions.isNotEmpty) 'instructions': instructions,
      'isActive': isActive,
    };
  }

  CompanyPaymentAccountModel copyWith({
    String? id,
    String? provider,
    String? title,
    String? number,
    String? handle,
    String? accountHolder,
    String? bankName,
    String? iban,
    String? instructions,
    bool? isActive,
  }) {
    return CompanyPaymentAccountModel(
      id: id ?? this.id,
      provider: provider ?? this.provider,
      title: title ?? this.title,
      number: number ?? this.number,
      handle: handle ?? this.handle,
      accountHolder: accountHolder ?? this.accountHolder,
      bankName: bankName ?? this.bankName,
      iban: iban ?? this.iban,
      instructions: instructions ?? this.instructions,
      isActive: isActive ?? this.isActive,
    );
  }

  String get displayAddress {
    if (handle.isNotEmpty) return handle;
    if (number.isNotEmpty) return number;
    if (iban.isNotEmpty) return iban;
    return title;
  }
}
