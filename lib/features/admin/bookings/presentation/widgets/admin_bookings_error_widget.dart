import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class AdminBookingsErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const AdminBookingsErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(errorMessage, style: AppTextStyles.bodyMedium),
          AppSizes.p16.verticalSpace,
          ElevatedButton(
            onPressed: onRetry,
            child: Text(AppStrings.retry),
          ),
        ],
      ),
    );
  }
}
