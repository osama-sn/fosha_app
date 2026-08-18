import 'chat_message_model.dart';

class ChatModel {
  final String id;
  final String type;
  final String userId;
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
    if (json['user'] != null) {
      if (json['user'] is Map) {
        userIdVal = (json['user']['_id'] ?? json['user']['id'] ?? '').toString();
      } else {
        userIdVal = json['user'].toString();
      }
    }

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
