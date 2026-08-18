import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/shared/widgets/app_network_image.dart';
import 'package:fosha_app/core/utils/url_launcher_helper.dart';
import 'package:fosha_app/core/utils/chat_time_formatter.dart';
import 'package:fosha_app/features/chat/presentation/cubit/chat_cubit.dart';

class ChatPage extends StatelessWidget {
  final String companyId;
  final String? companyName;
  final String? companyPhone;
  final String? tripId;
  final String? bookingId;

  const ChatPage({
    super.key,
    required this.companyId,
    this.companyName,
    this.companyPhone,
    this.tripId,
    this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatCubit>(
      create: (context) => getIt<ChatCubit>()
        ..initChat(
          companyId: companyId,
          tripId: tripId,
          bookingId: bookingId,
        ),
      child: _ChatPageBody(
        companyName: companyName ?? 'محادثة الشركة',
        companyPhone: companyPhone ?? '+201011111111',
      ),
    );
  }
}

class _ChatPageBody extends StatefulWidget {
  final String companyName;
  final String companyPhone;

  const _ChatPageBody({
    required this.companyName,
    required this.companyPhone,
  });

  @override
  State<_ChatPageBody> createState() => _ChatPageBodyState();
}

class _ChatPageBodyState extends State<_ChatPageBody> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  File? _selectedImage;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted) {
        context.read<ChatCubit>().refreshMessagesSilent();
      }
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isEmpty && _selectedImage == null) return;

    context.read<ChatCubit>().sendMessage(
          text: text.isNotEmpty ? text : 'صورة مرفقة',
          imageFile: _selectedImage,
        );

    _msgController.clear();
    setState(() {
      _selectedImage = null;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: const Icon(Icons.business, color: AppColors.primary),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.companyName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'محادثة مباشرة مع خدمة العملاء',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_outlined, color: AppColors.primary),
            onPressed: () {
              UrlLauncherHelper.showContactOptionsModal(
                context: context,
                phone: widget.companyPhone,
                title: 'تواصل خارجي مع ${widget.companyName}',
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is ChatSuccess) {
            _scrollToBottom();
          }
        },
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: AppLoading());
          }

          if (state is ChatFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48.r, color: AppColors.error),
                  SizedBox(height: 12.h),
                  Text(state.error),
                  ElevatedButton(
                    onPressed: () => context.read<ChatCubit>().initChat(
                          companyId: '',
                        ),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is ChatSuccess) {
            final messages = state.messages;
            return Column(
              children: [
                Expanded(
                  child: messages.isEmpty
                      ? Center(
                          child: Text(
                            'ابدأ المحادثة الآن مع ${widget.companyName}',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14.sp,
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.all(16.r),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final msg = messages[index];
                            final isMe = !msg.isFromCompany;
                            final showDateHeader = index == 0 ||
                                !ChatTimeFormatter.isSameDay(
                                  msg.createdAt,
                                  messages[index - 1].createdAt,
                                );

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (showDateHeader)
                                  Center(
                                    child: Container(
                                      margin: EdgeInsets.symmetric(vertical: 12.h),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 14.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12.r),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.05),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        ChatTimeFormatter.formatDateHeader(msg.createdAt),
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                Align(
                                  alignment: isMe
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10.h),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 14.w,
                                      vertical: 10.h,
                                    ),
                                    constraints: BoxConstraints(
                                      maxWidth: 0.78.sw,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isMe
                                          ? AppColors.primary
                                          : Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16.r),
                                        topRight: Radius.circular(16.r),
                                        bottomLeft: Radius.circular(
                                            isMe ? 16.r : 2.r),
                                        bottomRight: Radius.circular(
                                            isMe ? 2.r : 16.r),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.06),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (msg.image != null &&
                                            msg.image!.isNotEmpty) ...[
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            child: AppNetworkImage(
                                              imageUrl: msg.image!,
                                              height: 160.h,
                                              width: double.infinity,
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                        ],
                                        if (msg.text.isNotEmpty)
                                          Text(
                                            msg.text,
                                            style: TextStyle(
                                              color: isMe
                                                  ? Colors.white
                                                  : AppColors.textPrimary,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        SizedBox(height: 4.h),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            const Spacer(),
                                            Text(
                                              ChatTimeFormatter.formatTime(msg.createdAt),
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                color: isMe
                                                    ? Colors.white.withValues(alpha: 0.75)
                                                    : AppColors.textSecondary,
                                              ),
                                            ),
                                            if (isMe) ...[
                                              SizedBox(width: 4.w),
                                              Icon(
                                                Icons.done_all,
                                                size: 13.r,
                                                color: Colors.white.withValues(alpha: 0.85),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ),
                if (_selectedImage != null)
                  Container(
                    padding: EdgeInsets.all(8.r),
                    color: Colors.grey.shade200,
                    child: Row(
                      children: [
                        Image.file(_selectedImage!,
                            width: 50.w, height: 50.h, fit: BoxFit.cover),
                        SizedBox(width: 10.w),
                        const Text('صورة مختارة للارسال'),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _selectedImage = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.image,
                            color: AppColors.textSecondary),
                        onPressed: _pickImage,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _msgController,
                          decoration: InputDecoration(
                            hintText: 'اكتب رسالتك هنا...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                          ),
                        ),
                      ),
                      state.isSending
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : IconButton(
                              icon: const Icon(Icons.send,
                                  color: AppColors.primary),
                              onPressed: _sendMessage,
                            ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
