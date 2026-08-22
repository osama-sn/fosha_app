import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/chat/data/models/chat_model.dart';
import 'package:fosha_app/features/chat/presentation/pages/chat_page.dart';

class AdminChatItemWidget extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback onChatOpened;

  const AdminChatItemWidget({
    super.key,
    required this.chat,
    required this.onChatOpened,
  });

  @override
  Widget build(BuildContext context) {
    final rawName = chat.userName ?? '';
    final displayName = rawName.isNotEmpty
        ? (rawName == 'الادمن' ? 'محادثة تجريبية (الادمن)' : rawName)
        : AppStrings.adminDefaultCustomerName;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatPage(
              chatId: chat.id,
              initialChat: chat,
              companyId: chat.companyId,
              companyName: displayName,
              companyPhone: chat.userPhone,
              tripId: chat.tripId,
              bookingId: chat.bookingId,
            ),
          ),
        ).then((_) => onChatOpened());
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              child: Text(
                displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (chat.userPhone != null &&
                      chat.userPhone!.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      chat.userPhone!,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                  SizedBox(height: 4.h),
                  Text(
                    chat.lastMessage.isNotEmpty
                        ? chat.lastMessage
                        : AppStrings.adminTapToReply,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (chat.unreadCountUser > 0) ...[
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${chat.unreadCountUser}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            SizedBox(width: 6.w),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.r,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
