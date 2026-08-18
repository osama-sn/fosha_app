class ChatMessageModel {
  final String id;
  final String senderId;
  final String senderType; // 'user' or 'company'
  final String text;
  final String? image;
  final DateTime createdAt;

  ChatMessageModel({
    required this.id,
    required this.senderId,
    required this.senderType,
    required this.text,
    this.image,
    required this.createdAt,
  });

  bool get isFromCompany {
    final typeLower = senderType.toLowerCase();
    return typeLower == 'company' ||
        typeLower == 'companyprofile' ||
        typeLower == 'company_admin' ||
        typeLower == 'admin';
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    String senderIdVal = '';
    String senderTypeVal = 'user';

    if (json['senderType'] != null && json['senderType'].toString().isNotEmpty) {
      senderTypeVal = json['senderType'].toString();
    } else if (json['senderModel'] != null &&
        json['senderModel'].toString().isNotEmpty) {
      senderTypeVal = json['senderModel'].toString();
    } else if (json['senderRole'] != null &&
        json['senderRole'].toString().isNotEmpty) {
      senderTypeVal = json['senderRole'].toString();
    } else if (json['role'] != null && json['role'].toString().isNotEmpty) {
      senderTypeVal = json['role'].toString();
    } else if (json['sender'] is Map) {
      final sMap = Map<String, dynamic>.from(json['sender'] as Map);
      if (sMap['role'] != null) {
        senderTypeVal = sMap['role'].toString();
      } else if (sMap['type'] != null) {
        senderTypeVal = sMap['type'].toString();
      } else if (sMap['senderType'] != null) {
        senderTypeVal = sMap['senderType'].toString();
      }
    } else if (json['sender'] is String) {
      final sStr = json['sender'].toString();
      if (sStr.toLowerCase() == 'company' ||
          sStr.toLowerCase() == 'companyprofile' ||
          sStr.toLowerCase() == 'admin') {
        senderTypeVal = sStr;
      }
    }

    if (json['sender'] != null) {
      if (json['sender'] is Map) {
        senderIdVal =
            (json['sender']['_id'] ?? json['sender']['id'] ?? '').toString();
      } else {
        senderIdVal = json['sender'].toString();
      }
    } else if (json['senderId'] != null) {
      senderIdVal = json['senderId'].toString();
    }

    return ChatMessageModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      senderId: senderIdVal,
      senderType: senderTypeVal,
      text: json['text'] as String? ?? json['message'] as String? ?? '',
      image: json['image'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : (json['timestamp'] != null
              ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
              : DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'senderId': senderId,
      'senderType': senderType,
      'text': text,
      'image': image,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
