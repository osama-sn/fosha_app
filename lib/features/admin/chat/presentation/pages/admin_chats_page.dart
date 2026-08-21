import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:fosha_app/features/chat/presentation/pages/chat_page.dart';

class AdminChatsPage extends StatelessWidget {
  const AdminChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatCubit>(
      create: (context) => getIt<ChatCubit>()..loadUserChats(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0.5,
          title: Text(
            'الشات والتواصل مع العملاء',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            if (state is ChatLoading) {
              return const Center(child: AppLoading());
            }

            if (state is ChatFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_outline,
                        size: 64.r, color: Colors.grey),
                    SizedBox(height: 12.h),
                    Text(
                      state.error,
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () => context.read<ChatCubit>().loadUserChats(),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            if (state is UserChatsLoaded) {
              final chats = state.chats;
              if (chats.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.forum_outlined,
                          size: 72.r,
                          color: AppColors.primary.withValues(alpha: 0.4)),
                      SizedBox(height: 16.h),
                      Text(
                        'لا توجد محادثات جارية حالياً مع العملاء',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'ستظهر استفسارات ورسائل العملاء هنا عند التواصل معكم',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<ChatCubit>().loadUserChats();
                },
                child: ListView.separated(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  itemCount: chats.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    final rawName = chat.userName ?? '';
                    final displayName = rawName.isNotEmpty
                        ? (rawName == 'الادمن'
                            ? 'محادثة تجريبية (الادمن)'
                            : rawName)
                        : 'عميل فسحة';

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
                        ).then((_) {
                          if (context.mounted) {
                            context.read<ChatCubit>().loadUserChats();
                          }
                        });
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
                              backgroundColor:
                                  AppColors.primary.withValues(alpha: 0.15),
                              child: Text(
                                displayName.isNotEmpty
                                    ? displayName[0].toUpperCase()
                                    : 'U',
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
                                          fontSize: 11.sp),
                                    ),
                                  ],
                                  SizedBox(height: 4.h),
                                  Text(
                                    chat.lastMessage.isNotEmpty
                                        ? chat.lastMessage
                                        : 'اضغط للرد على المحادثة...',
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
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
