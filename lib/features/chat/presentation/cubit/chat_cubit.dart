import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fosha_app/features/chat/data/models/chat_message_model.dart';
import 'package:fosha_app/features/chat/data/models/chat_model.dart';
import 'package:fosha_app/features/chat/data/repositories/chat_repository.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}
class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {
  final ChatModel chat;
  final List<ChatMessageModel> messages;
  final bool isSending;

  const ChatSuccess({
    required this.chat,
    required this.messages,
    this.isSending = false,
  });

  ChatSuccess copyWith({
    ChatModel? chat,
    List<ChatMessageModel>? messages,
    bool? isSending,
  }) {
    return ChatSuccess(
      chat: chat ?? this.chat,
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
    );
  }

  @override
  List<Object?> get props => [chat, messages, isSending];
}

class ChatFailure extends ChatState {
  final String error;
  const ChatFailure(this.error);
  @override
  List<Object?> get props => [error];
}

class UserChatsLoaded extends ChatState {
  final List<ChatModel> chats;
  const UserChatsLoaded(this.chats);
  @override
  List<Object?> get props => [chats];
}

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;

  ChatCubit({required this.repository}) : super(ChatInitial());

  Future<void> initChat({
    required String companyId,
    String? chatId,
    String? tripId,
    String? bookingId,
    ChatModel? initialChat,
  }) async {
    emit(ChatLoading());

    if (initialChat != null) {
      final msgResult = await repository.getMessages(chatId: initialChat.id);
      msgResult.fold(
        (f) => emit(ChatSuccess(chat: initialChat, messages: initialChat.messages)),
        (msgs) => emit(ChatSuccess(chat: initialChat, messages: msgs)),
      );
      return;
    }

    if (chatId != null && chatId.isNotEmpty) {
      final msgResult = await repository.getMessages(chatId: chatId);
      await msgResult.fold(
        (failure) async {
          _startOrGetChat(companyId: companyId, tripId: tripId, bookingId: bookingId);
        },
        (msgs) async {
          final dummyChat = ChatModel(
            id: chatId,
            type: 'booking_related',
            userId: '',
            companyId: companyId,
            messages: msgs,
          );
          emit(ChatSuccess(chat: dummyChat, messages: msgs));
        },
      );
      return;
    }

    await _startOrGetChat(
      companyId: companyId,
      tripId: tripId,
      bookingId: bookingId,
    );
  }

  Future<void> _startOrGetChat({
    required String companyId,
    String? tripId,
    String? bookingId,
  }) async {
    final chatResult = await repository.startOrGetChat(
      companyId: companyId,
      tripId: tripId,
      bookingId: bookingId,
    );

    await chatResult.fold(
      (failure) async {
        emit(ChatFailure(failure.message));
      },
      (chat) async {
        if (chat.messages.isNotEmpty) {
          emit(ChatSuccess(chat: chat, messages: chat.messages));
        } else {
          final msgResult = await repository.getMessages(chatId: chat.id);
          msgResult.fold(
            (f) => emit(ChatSuccess(chat: chat, messages: const [])),
            (msgs) => emit(ChatSuccess(chat: chat, messages: msgs)),
          );
        }
      },
    );
  }

  Future<void> sendMessage({
    required String text,
    dynamic imageFile,
  }) async {
    final currentState = state;
    if (currentState is! ChatSuccess) return;

    emit(currentState.copyWith(isSending: true));

    final result = await repository.sendMessage(
      chatId: currentState.chat.id,
      text: text,
      imageFile: imageFile,
    );

    result.fold(
      (failure) {
        emit(currentState.copyWith(isSending: false));
      },
      (newMessage) {
        final updatedMsgs = List<ChatMessageModel>.from(currentState.messages)
          ..add(newMessage);
        emit(currentState.copyWith(
          messages: updatedMsgs,
          isSending: false,
        ));
      },
    );
  }

  Future<void> refreshMessagesSilent() async {
    final currentState = state;
    if (currentState is! ChatSuccess) return;

    final result = await repository.getMessages(chatId: currentState.chat.id);
    result.fold(
      (failure) => null,
      (newMessages) {
        if (newMessages.length != currentState.messages.length ||
            (newMessages.isNotEmpty &&
                currentState.messages.isNotEmpty &&
                newMessages.last.id != currentState.messages.last.id)) {
          emit(currentState.copyWith(messages: newMessages));
        }
      },
    );
  }

  Future<void> loadUserChats() async {
    emit(ChatLoading());
    final result = await repository.getUserChats();
    result.fold(
      (failure) => emit(ChatFailure(failure.message)),
      (chats) => emit(UserChatsLoaded(chats)),
    );
  }
}
