import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/shared/widgets/app_button.dart';
import 'package:fosha_app/core/shared/widgets/app_snackbar.dart';

class AdminAnnouncementDialog extends StatefulWidget {
  final String tripId;
  final Function(String title, String message) onSend;

  const AdminAnnouncementDialog({
    super.key,
    required this.tripId,
    required this.onSend,
  });

  static Future<void> show(
    BuildContext context, {
    required String tripId,
    required Function(String title, String message) onSend,
  }) {
    return showDialog(
      context: context,
      builder: (_) => AdminAnnouncementDialog(
        tripId: tripId,
        onSend: onSend,
      ),
    );
  }

  @override
  State<AdminAnnouncementDialog> createState() =>
      _AdminAnnouncementDialogState();
}

class _AdminAnnouncementDialogState extends State<AdminAnnouncementDialog> {
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_titleController.text.trim().isEmpty ||
        _messageController.text.trim().isEmpty) {
      AppSnackbar.showError(
        context: context,
        message: AppStrings.adminEnterTitleAndMessage,
      );
      return;
    }
    Navigator.pop(context);
    widget.onSend(
      _titleController.text.trim(),
      _messageController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: Row(
        children: [
          const Icon(Icons.campaign, color: AppColors.primary),
          SizedBox(width: 8.w),
          Text(AppStrings.adminSendUrgentNotification),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: AppStrings.adminNotificationTitleLabel,
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: _messageController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: AppStrings.adminNotificationMessageLabel,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppStrings.cancel),
        ),
        AppButton(
          text: AppStrings.adminSendNow,
          onPressed: _submit,
        ),
      ],
    );
  }
}
