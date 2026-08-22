import 'package:equatable/equatable.dart';
import 'package:fosha_app/features/chat/data/models/chat_message_model.dart';
import 'package:fosha_app/features/chat/data/models/chat_model.dart';

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
