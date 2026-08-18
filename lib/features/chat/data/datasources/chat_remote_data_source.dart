import 'package:dio/dio.dart';
import 'package:fosha_app/core/network/api_endpoints.dart';
import 'package:fosha_app/core/network/dio_client.dart';
import 'package:fosha_app/features/chat/data/models/chat_message_model.dart';
import 'package:fosha_app/features/chat/data/models/chat_model.dart';

abstract class ChatRemoteDataSource {
  Future<ChatModel> startOrGetChat({
    required String companyId,
    String? tripId,
    String? bookingId,
    String type = 'booking_related',
  });

  Future<List<ChatMessageModel>> getMessages({
    required String chatId,
    int page = 1,
    int limit = 50,
  });

  Future<ChatMessageModel> sendMessage({
    required String chatId,
    required String text,
    dynamic imageFile,
  });

  Future<List<ChatModel>> getUserChats();
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final DioClient dioClient;

  ChatRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<ChatModel> startOrGetChat({
    required String companyId,
    String? tripId,
    String? bookingId,
    String type = 'booking_related',
  }) async {
    try {
      final body = <String, dynamic>{
        'companyId': companyId,
        'type': type,
        if (tripId != null && tripId.isNotEmpty) 'tripId': tripId,
        if (bookingId != null && bookingId.isNotEmpty) 'bookingId': bookingId,
      };

      final response = await dioClient.dio.post(
        ApiEndpoints.chats,
        data: body,
      );

      final resData = response.data as Map<String, dynamic>;
      final chatJson = (resData['data'] is Map)
          ? Map<String, dynamic>.from(resData['data'] as Map)
          : resData;

      return ChatModel.fromJson(chatJson);
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message']?.toString() ?? e.message ?? 'فشل فتح المحادثة';
      throw Exception(errorMsg);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ChatMessageModel>> getMessages({
    required String chatId,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await dioClient.dio.get(
        '${ApiEndpoints.chats}/$chatId/messages',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final resData = response.data as Map<String, dynamic>;
      List listData = [];
      if (resData['data'] is List) {
        listData = resData['data'] as List;
      } else if (resData['data'] is Map && resData['data']['messages'] is List) {
        listData = resData['data']['messages'] as List;
      }

      return listData
          .map((e) => ChatMessageModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message']?.toString() ?? e.message ?? 'فشل جلب الرسائل';
      throw Exception(errorMsg);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ChatMessageModel> sendMessage({
    required String chatId,
    required String text,
    dynamic imageFile,
  }) async {
    try {
      dynamic data;
      if (imageFile != null) {
        final formData = FormData.fromMap({
          'text': text,
          'image': await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
        });
        data = formData;
      } else {
        data = {'text': text};
      }

      final response = await dioClient.dio.post(
        '${ApiEndpoints.chats}/$chatId/messages',
        data: data,
      );

      final resData = response.data as Map<String, dynamic>;
      final msgJson = (resData['data'] is Map)
          ? Map<String, dynamic>.from(resData['data'] as Map)
          : resData;

      return ChatMessageModel.fromJson(msgJson);
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message']?.toString() ?? e.message ?? 'فشل إرسال الرسالة';
      throw Exception(errorMsg);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ChatModel>> getUserChats() async {
    try {
      final response = await dioClient.dio.get(ApiEndpoints.chats);
      final resData = response.data as Map<String, dynamic>;
      List listData = [];
      if (resData['data'] is List) {
        listData = resData['data'] as List;
      } else if (resData['chats'] is List) {
        listData = resData['chats'] as List;
      } else if (resData['data'] is Map && resData['data']['chats'] is List) {
        listData = resData['data']['chats'] as List;
      }

      return listData
          .map((e) => ChatModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message']?.toString() ?? e.message ?? 'فشل جلب قائمة المحادثات';
      throw Exception(errorMsg);
    } catch (e) {
      rethrow;
    }
  }
}
