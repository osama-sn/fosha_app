import 'package:dartz/dartz.dart';
import 'package:fosha_app/core/errors/failures.dart';
import 'package:fosha_app/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:fosha_app/features/chat/data/models/chat_message_model.dart';
import 'package:fosha_app/features/chat/data/models/chat_model.dart';

class ChatRepository {
  final ChatRemoteDataSource dataSource;

  ChatRepository({required this.dataSource});

  Future<Either<Failure, ChatModel>> startOrGetChat({
    required String companyId,
    String? tripId,
    String? bookingId,
    String type = 'booking_related',
  }) async {
    try {
      final chat = await dataSource.startOrGetChat(
        companyId: companyId,
        tripId: tripId,
        bookingId: bookingId,
        type: type,
      );
      return Right(chat);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<ChatMessageModel>>> getMessages({
    required String chatId,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final messages = await dataSource.getMessages(
        chatId: chatId,
        page: page,
        limit: limit,
      );
      return Right(messages);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, ChatMessageModel>> sendMessage({
    required String chatId,
    required String text,
    dynamic imageFile,
  }) async {
    try {
      final message = await dataSource.sendMessage(
        chatId: chatId,
        text: text,
        imageFile: imageFile,
      );
      return Right(message);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<ChatModel>>> getUserChats() async {
    try {
      final chats = await dataSource.getUserChats();
      return Right(chats);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
