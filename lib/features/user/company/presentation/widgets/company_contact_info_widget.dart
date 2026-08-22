import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/company_profile/data/models/company_profile_model.dart';

class CompanyContactInfoWidget extends StatelessWidget {
  final CompanyProfileModel? profile;

  const CompanyContactInfoWidget({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildContactRow(
            Icons.phone_outlined,
            profile?.contactPhone.isNotEmpty == true
                ? profile!.contactPhone
                : '+20 100 123 4567',
          ),
          const Divider(color: AppColors.border, height: 1),
          _buildContactRow(
            Icons.email_outlined,
            profile?.contactEmail.isNotEmpty == true
                ? profile!.contactEmail
                : 'info@rehlatmasr.com',
          ),
          const Divider(color: AppColors.border, height: 1),
          _buildContactRow(Icons.language_outlined, 'www.rehlatmasr.com'),
          const Divider(color: AppColors.border, height: 1),
          _buildContactRow(
            Icons.location_on_outlined,
            profile?.address.isNotEmpty == true
                ? '${profile!.address} - ${profile!.governorate}'
                : '123 شارع النيل، الزمالك، القاهرة، مصر',
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        children: [
          Icon(icon, size: 20.r, color: AppColors.primaryDark),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
