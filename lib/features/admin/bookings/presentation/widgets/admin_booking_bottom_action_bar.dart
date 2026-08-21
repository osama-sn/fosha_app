import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/extensions/extensions.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/core/utils/url_launcher_helper.dart';
import 'package:fosha_app/features/admin/bookings/presentation/cubit/admin_bookings_cubit.dart';
import 'package:fosha_app/features/chat/presentation/pages/chat_page.dart';

class AdminBookingBottomActionBar extends StatelessWidget {
  final String customerName;
  final String customerPhone;
  final String? bookingId;
  final String? userId;
  final VoidCallback onCancelBooking;

  const AdminBookingBottomActionBar({
    super.key,
    required this.customerName,
    required this.customerPhone,
    this.bookingId,
    this.userId,
    required this.onCancelBooking,
  });

  Future<void> _openCustomerInAppChat(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: AppLoading()),
    );

    try {
      final cubit = context.read<AdminBookingsCubit>();
      final target = await cubit.prepareCustomerChatTarget(
        customerName: customerName,
        customerPhone: customerPhone,
        bookingId: bookingId,
        userId: userId,
      );

      if (!context.mounted) return;
      Navigator.pop(context);

      if (target != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatPage(
              chatId: target.chatId,
              initialChat: target.existingChat,
              companyId: target.companyId,
              companyName: target.customerName,
              companyPhone: target.customerPhone,
              bookingId: target.bookingId,
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppStrings.adminChatOpenError}: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showContactOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (modalContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${AppStrings.adminContactCustomer} ${customerName.isNotEmpty ? customerName : ""}',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 16.h),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  child: const Icon(Icons.forum_rounded, color: AppColors.primary),
                ),
                title: Text(
                  AppStrings.adminContactInAppChat,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(AppStrings.adminContactInAppChatSubtitle),
                onTap: () {
                  Navigator.pop(modalContext);
                  _openCustomerInAppChat(context);
                },
              ),
              const Divider(),
              if (customerPhone.isNotEmpty) ...[
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.whatsApp,
                    child: Icon(Icons.chat_bubble, color: Colors.white),
                  ),
                  title: Text(
                    AppStrings.adminContactWhatsApp,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(customerPhone),
                  onTap: () {
                    Navigator.pop(modalContext);
                    UrlLauncherHelper.launchWhatsApp(
                      context: context,
                      phone: customerPhone,
                      message: AppStrings.adminContactWhatsAppMessage(customerName),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.phone, color: Colors.white),
                  ),
                  title: Text(
                    AppStrings.adminContactPhoneCall,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(customerPhone),
                  onTap: () {
                    Navigator.pop(modalContext);
                    UrlLauncherHelper.makePhoneCall(
                      context: context,
                      phone: customerPhone,
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.p16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 10.r,
            offset: Offset(0, -3.h),
          ),
        ],
      ),
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: onCancelBooking,
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            label: Text(
              AppStrings.adminCancelBooking,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.error),
              padding: EdgeInsets.symmetric(vertical: AppSizes.p12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.r12),
              ),
            ),
          ).expanded(),
          AppSizes.p16.horizontalSpace,
          ElevatedButton.icon(
            onPressed: () => _showContactOptions(context),
            icon: const Icon(Icons.headset_mic_outlined, color: Colors.white),
            label: Text(
              AppStrings.adminContactCustomer,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(vertical: AppSizes.p12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.r12),
              ),
            ),
          ).expanded(),
        ],
      ),
    );
  }
}
