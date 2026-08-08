import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/extensions/extensions.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';

class ProfileAvatarPicker extends StatelessWidget {
  final String? imagePath;
  final VoidCallback? onTap;

  const ProfileAvatarPicker({
    super.key,
    this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath != null && imagePath!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 40.r,
                backgroundColor: AppColors.divider,
                backgroundImage: hasImage ? FileImage(File(imagePath!)) : null,
                child: !hasImage
                    ? Icon(Icons.person, size: 40.sp, color: AppColors.textHint)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surface, width: 2),
                  ),
                  child: Icon(Icons.camera_alt, size: 16.sp, color: Colors.white),
                ),
              ),
            ],
          ).center(),
          AppSizes.p8.verticalSpace,
          Text(
            AppStrings.profilePhotoOptional,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textHint,
            ),
          ).center(),
        ],
      ),
    );
  }
}
