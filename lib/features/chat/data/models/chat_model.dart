import 'chat_message_model.dart';

class ChatModel {
  final String id;
  final String type;
  final String userId;
  final String? userName;
  final String? userPhone;
  final String companyId;
  final String? companyName;
  final String? companyLogo;
  final String? tripId;
  final String? bookingId;
  final int unreadCountUser;
  final String lastMessage;
  final List<ChatMessageModel> messages;

  ChatModel({
    required this.id,
    required this.type,
    required this.userId,
    this.userName,
    this.userPhone,
    required this.companyId,
    this.companyName,
    this.companyLogo,
    this.tripId,
    this.bookingId,
    this.unreadCountUser = 0,
    this.lastMessage = '',
    this.messages = const [],
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    String userIdVal = '';
    String? uName;
    String? uPhone;

    void extractUserFrom(Map<String, dynamic> uMap) {
      final id = (uMap['_id'] ?? uMap['id'] ?? '').toString();
      if (id.isNotEmpty && userIdVal.isEmpty) {
        userIdVal = id;
      }
      final name = uMap['fullName'] as String? ?? uMap['name'] as String?;
      if (name != null && name.isNotEmpty) {
        if (uName == null || uName == 'الادمن') {
          uName = name;
        }
      }
      final phone = uMap['phone'] as String?;
      if (phone != null && phone.isNotEmpty) {
        if (uPhone == null || uPhone == '01099999991') {
          uPhone = phone;
        }
      }
    }

    if (json['customer'] is Map) {
      extractUserFrom(Map<String, dynamic>.from(json['customer'] as Map));
    }
    if (json['client'] is Map) {
      extractUserFrom(Map<String, dynamic>.from(json['client'] as Map));
    }
    if (json['participants'] is List) {
      for (var p in json['participants'] as List) {
        if (p is Map) {
          final pMap = Map<String, dynamic>.from(p);
          final pName = pMap['fullName'] as String? ?? pMap['name'] as String? ?? '';
          if (pName.isNotEmpty && pName != 'الادمن' && pMap['role'] != 'admin') {
            extractUserFrom(pMap);
            break;
          }
        }
      }
    }
    if (json['user'] is Map) {
      extractUserFrom(Map<String, dynamic>.from(json['user'] as Map));
    } else if (json['user'] != null && userIdVal.isEmpty) {
      userIdVal = json['user'].toString();
    }

    uName ??= json['userName'] as String? ?? json['customerName'] as String?;
    uPhone ??= json['userPhone'] as String? ?? json['customerPhone'] as String?;

    String companyIdVal = '';
    String? compName;
    String? compLogo;
    if (json['company'] != null) {
      if (json['company'] is Map) {
        final compMap = Map<String, dynamic>.from(json['company'] as Map);
        companyIdVal = (compMap['_id'] ?? compMap['id'] ?? '').toString();
        compName = compMap['name'] as String? ?? compMap['fullName'] as String?;
        compLogo = compMap['logo'] as String? ?? compMap['profileImage'] as String?;
      } else {
        companyIdVal = json['company'].toString();
      }
    }

    List<ChatMessageModel> msgList = [];
    if (json['messages'] is List) {
      msgList = (json['messages'] as List)
          .map((e) => ChatMessageModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }

    return ChatModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      type: json['type'] as String? ?? 'booking_related',
      userId: userIdVal,
      userName: uName,
      userPhone: uPhone,
      companyId: companyIdVal,
      companyName: compName,
      companyLogo: compLogo,
      tripId: json['trip'] != null ? (json['trip'] is Map ? json['trip']['_id']?.toString() : json['trip'].toString()) : null,
      bookingId: json['booking'] != null ? (json['booking'] is Map ? json['booking']['_id']?.toString() : json['booking'].toString()) : null,
      unreadCountUser: json['unreadCountUser'] as int? ?? 0,
      lastMessage: json['lastMessage'] as String? ?? '',
      messages: msgList,
    );
  }
}
