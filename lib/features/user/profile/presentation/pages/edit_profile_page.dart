import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/network/api_endpoints.dart';
import 'package:fosha_app/core/shared/widgets/app_button.dart';
import 'package:fosha_app/core/shared/widgets/app_snackbar.dart';
import 'package:fosha_app/core/shared/widgets/app_text_field.dart';
import 'package:fosha_app/core/theme/app_sizes.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/user/auth/data/models/user_model.dart';
import 'package:fosha_app/features/user/profile/presentation/cubit/profile_cubit.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel? user;

  const EditProfilePage({super.key, this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  String? _selectedGovernorate;
  File? _selectedImage;

  static const List<String> _egyptGovernorates = [
    'القاهرة',
    'الجيزة',
    'الإسكندرية',
    'الدقهلية',
    'الشرقية',
    'القليوبية',
    'كفر الشيخ',
    'المنوفية',
    'الغربية',
    'البحيرة',
    'الإسماعيلية',
    'بورسعيد',
    'السويس',
    'الفيوم',
    'بني سويف',
    'المنيا',
    'أسيوط',
    'سوهاج',
    'قنا',
    'الأقصر',
    'أسوان',
    'البحر الأحمر',
    'الوادي الجديد',
    'مطروح',
    'شمال سيناء',
    'جنوب سيناء',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.fullName ?? '');
    _phoneController = TextEditingController(text: widget.user?.phone ?? '');
    if (widget.user?.governorate != null &&
        _egyptGovernorates.contains(widget.user!.governorate)) {
      _selectedGovernorate = widget.user!.governorate;
    } else {
      _selectedGovernorate = _egyptGovernorates.first;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>(
      create: (context) => getIt<ProfileCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'تعديل الملف الشخصي',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileFailure) {
              AppSnackbar.showError(
                context: context,
                message: state.error,
              );
            } else if (state is ProfileSuccess) {
              AppSnackbar.showSuccess(
                context: context,
                message: 'تم تحديث بياناتك الشخصية بنجاح! ✨',
              );
              Navigator.pop(context, true);
            }
          },
          builder: (context, state) {
            final profileImgUrl = ApiEndpoints.getImageUrl(widget.user?.profileImage);

            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSizes.p24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppSizes.p16.verticalSpace,
                      // Avatar picker
                      GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 54.r,
                              backgroundColor: AppColors.border,
                              backgroundImage: _selectedImage != null
                                  ? FileImage(_selectedImage!) as ImageProvider
                                  : (profileImgUrl.isNotEmpty &&
                                          (profileImgUrl.startsWith('http://') ||
                                              profileImgUrl.startsWith('https://'))
                                      ? NetworkImage(profileImgUrl) as ImageProvider
                                      : null),
                              child: (_selectedImage == null &&
                                      (profileImgUrl.isEmpty ||
                                          (!profileImgUrl.startsWith('http://') &&
                                              !profileImgUrl.startsWith('https://'))))
                                  ? Icon(Icons.person, size: 54.r, color: Colors.grey)
                                  : null,
                            ),
                            Container(
                              padding: EdgeInsets.all(AppSizes.p6),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppSizes.p8.verticalSpace,
                      Text(
                        'تغيير الصورة الشخصية',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSizes.p32.verticalSpace,
                      // Name field
                      AppTextField(
                        controller: _nameController,
                        labelText: 'الاسم بالكامل',
                        hintText: 'أدخل اسمك بالكامل',
                        type: AppTextFieldType.text,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'الرجاء إدخال الاسم بالكامل' : null,
                      ),
                      AppSizes.p16.verticalSpace,
                      // Phone field
                      AppTextField(
                        controller: _phoneController,
                        labelText: 'رقم الهاتف',
                        hintText: 'أدخل رقم الهاتف (مثال: 01012345678)',
                        type: AppTextFieldType.phone,
                      ),
                      AppSizes.p16.verticalSpace,
                      // Governorate selection dropdown
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'المحافظة',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedGovernorate,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: const BorderSide(color: AppColors.border),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: const BorderSide(color: AppColors.border),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: const BorderSide(color: AppColors.primary),
                              ),
                            ),
                            items: _egyptGovernorates
                                .map(
                                  (gov) => DropdownMenuItem<String>(
                                    value: gov,
                                    child: Text(gov),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _selectedGovernorate = val;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      AppSizes.p32.verticalSpace,
                      // Submit button
                      AppButton(
                        text: 'حفظ التعديلات',
                        isLoading: state is ProfileLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<ProfileCubit>().updateProfile(
                                  fullName: _nameController.text.trim(),
                                  phone: _phoneController.text.trim(),
                                  governorate: _selectedGovernorate,
                                  imageFile: _selectedImage,
                                );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
