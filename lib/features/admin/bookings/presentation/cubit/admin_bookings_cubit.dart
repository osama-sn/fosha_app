import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/features/admin/bookings/data/constants/admin_bookings_constants.dart';
import 'package:fosha_app/features/admin/bookings/data/repositories/admin_bookings_repository.dart';
import 'package:fosha_app/features/admin/bookings/presentation/cubit/admin_bookings_state.dart';
import 'package:fosha_app/features/admin/dashboard/data/repositories/admin_dashboard_stats_repository.dart';
import 'package:fosha_app/features/chat/data/models/chat_model.dart';
import 'package:fosha_app/features/chat/data/repositories/chat_repository.dart';

class AdminChatTarget {
  final String? chatId;
  final ChatModel? existingChat;
  final String companyId;
  final String customerName;
  final String customerPhone;
  final String? bookingId;

  const AdminChatTarget({
    this.chatId,
    this.existingChat,
    required this.companyId,
    required this.customerName,
    required this.customerPhone,
    this.bookingId,
  });
}

class AdminBookingsCubit extends Cubit<AdminBookingsState> {
  final AdminBookingsRepository _repository;
  final ChatRepository? _chatRepository;
  final AdminDashboardStatsRepository? _statsRepository;

  AdminBookingsCubit({
    required AdminBookingsRepository repository,
    ChatRepository? chatRepository,
    AdminDashboardStatsRepository? statsRepository,
  })  : _repository = repository,
        _chatRepository = chatRepository,
        _statsRepository = statsRepository,
        super(AdminBookingsInitial());

  Future<void> fetchBookings({String? statusFilter}) async {
    emit(AdminBookingsLoading());
    final result = await _repository.getBookings(status: statusFilter);

    result.fold(
      (failure) => emit(AdminBookingsError(failure.message)),
      (bookings) => emit(
        AdminBookingsLoaded(
          bookings: bookings,
          activeStatusFilter: statusFilter ?? AdminBookingsConstants.statusAll,
        ),
      ),
    );
  }

  Future<void> updateStatus({
    required String bookingId,
    required String newStatus,
    String? rejectionReason,
  }) async {
    final currentState = state;
    if (currentState is AdminBookingsLoaded) {
      emit(currentState.copyWith(isUpdatingStatus: true));

      final result = await _repository.updateBookingStatus(
        bookingId,
        status: newStatus,
        rejectionReason: rejectionReason,
      );

      result.fold(
        (failure) => emit(AdminBookingsError(failure.message)),
        (updatedBooking) {
          final updatedList = currentState.bookings.map((b) {
            return b.id == bookingId ? updatedBooking : b;
          }).toList();

          final successMsg =
              (newStatus == AdminBookingsConstants.statusApproved ||
                      newStatus == AdminBookingsConstants.statusAccepted)
                  ? AppStrings.adminStatusUpdateSuccessApprove
                  : AppStrings.adminStatusUpdateSuccessReject;

          emit(
            currentState.copyWith(
              bookings: updatedList,
              isUpdatingStatus: false,
              actionSuccessMessage: successMsg,
            ),
          );
        },
      );
    }
  }

  Future<AdminChatTarget?> prepareCustomerChatTarget({
    required String customerName,
    required String customerPhone,
    String? bookingId,
    String? userId,
  }) async {
    final chatRepo = _chatRepository;
    if (chatRepo == null) return null;

    ChatModel? existingChat;
    final result = await chatRepo.getUserChats();

    result.fold(
      (_) {},
      (chats) {
        for (final chat in chats) {
          final matchBooking = bookingId != null &&
              bookingId.isNotEmpty &&
              chat.bookingId == bookingId;
          final matchUserId =
              userId != null && userId.isNotEmpty && chat.userId == userId;
          final matchPhone = customerPhone.isNotEmpty &&
              chat.userPhone != null &&
              chat.userPhone == customerPhone;
          final matchName = customerName.isNotEmpty &&
              chat.userName != null &&
              chat.userName == customerName;

          if (matchBooking || matchUserId || matchPhone || matchName) {
            existingChat = chat;
            break;
          }
        }
      },
    );

    final foundChat = existingChat;
    if (foundChat != null) {
      return AdminChatTarget(
        chatId: foundChat.id,
        existingChat: foundChat,
        companyId: foundChat.companyId,
        customerName: customerName.isNotEmpty
            ? customerName
            : AppStrings.adminDefaultCustomerName,
        customerPhone: customerPhone,
        bookingId: bookingId,
      );
    }

    String compId = '';
    final statsRepo = _statsRepository;
    if (statsRepo != null) {
      final statsResult = await statsRepo.getDashboardStats();
      statsResult.fold((_) {}, (stats) {
        compId = stats.company?.id ?? '';
      });
    }

    return AdminChatTarget(
      companyId: compId,
      customerName: customerName.isNotEmpty
          ? customerName
          : AppStrings.adminDefaultCustomerName,
      customerPhone: customerPhone,
      bookingId: bookingId,
    );
  }
}
