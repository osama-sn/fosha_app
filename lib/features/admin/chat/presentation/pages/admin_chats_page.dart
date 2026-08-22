import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/shared/widgets/app_button.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/chat/presentation/widgets/admin_chat_item_widget.dart';
import 'package:fosha_app/features/admin/chat/presentation/widgets/admin_chats_empty_view.dart';
import 'package:fosha_app/features/chat/presentation/cubit/chat_cubit.dart';

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
            AppStrings.adminChatsTitle,
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
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 64.r,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      state.error,
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    SizedBox(height: 16.h),
                    AppButton(
                      text: AppStrings.retry,
                      onPressed: () =>
                          context.read<ChatCubit>().loadUserChats(),
                    ),
                  ],
                ),
              );
            }

            if (state is UserChatsLoaded) {
              final chats = state.chats;
              if (chats.isEmpty) {
                return const AdminChatsEmptyView();
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<ChatCubit>().loadUserChats();
                },
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  itemCount: chats.length,
                  separatorBuilder: (_, _) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    return AdminChatItemWidget(
                      chat: chat,
                      onChatOpened: () {
                        if (context.mounted) {
                          context.read<ChatCubit>().loadUserChats();
                        }
                      },
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
