import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/constants/app_strings.dart';
import 'package:fosha_app/core/shared/widgets/app_button.dart';
import 'package:fosha_app/core/shared/widgets/app_snackbar.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/expenses/data/constants/admin_expenses_constants.dart';
import 'package:fosha_app/features/admin/trips/data/models/trip_model.dart';

class AddExpenseBottomSheet extends StatefulWidget {
  final List<TripModel> trips;
  final Function({
    required String title,
    required double amount,
    required String category,
    String? tripId,
    String? notes,
    String? receiptImageFile,
  }) onAddExpense;

  const AddExpenseBottomSheet({
    super.key,
    required this.trips,
    required this.onAddExpense,
  });

  static Future<void> show(
    BuildContext context, {
    required List<TripModel> trips,
    required Function({
      required String title,
      required double amount,
      required String category,
      String? tripId,
      String? notes,
      String? receiptImageFile,
    }) onAddExpense,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => AddExpenseBottomSheet(
        trips: trips,
        onAddExpense: onAddExpense,
      ),
    );
  }

  @override
  State<AddExpenseBottomSheet> createState() => _AddExpenseBottomSheetState();
}

class _AddExpenseBottomSheetState extends State<AddExpenseBottomSheet> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  String _category = AdminExpensesConstants.categoryHotel;
  String? _selectedTrip;
  File? _receiptImage;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _receiptImage = File(picked.path));
    }
  }

  void _submit() {
    if (_titleController.text.trim().isEmpty ||
        _amountController.text.trim().isEmpty) {
      AppSnackbar.showError(
        context: context,
        message: AppStrings.adminFillRequiredFields,
      );
      return;
    }

    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;

    Navigator.pop(context);
    widget.onAddExpense(
      title: _titleController.text.trim(),
      amount: amount,
      category: _category,
      tripId: _selectedTrip,
      notes: _notesController.text.trim(),
      receiptImageFile: _receiptImage?.path,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16.w,
        right: 16.w,
        top: 20.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                AppStrings.adminAddNewExpenseTitle,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: AppStrings.adminExpenseTitleLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppStrings.adminExpenseAmountLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12.h),

            // Category Selector
            Text(AppStrings.adminExpenseCategoryLabel, style: AppTextStyles.labelLarge),
            SizedBox(height: 6.h),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: AdminExpensesConstants.addableCategories.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Text(
                    AdminExpensesConstants.categoriesMap[cat] ?? cat,
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _category = val);
              },
            ),
            SizedBox(height: 12.h),

            // Trip Selector
            Text(AppStrings.adminExpenseTripLinkOptional, style: AppTextStyles.labelLarge),
            SizedBox(height: 6.h),
            DropdownButtonFormField<String?>(
              initialValue: _selectedTrip,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(AppStrings.adminExpenseNoTripLink),
                ),
                ...widget.trips.map((trip) => DropdownMenuItem(
                      value: trip.id,
                      child: Text(trip.title),
                    )),
              ],
              onChanged: (val) => setState(() => _selectedTrip = val),
            ),
            SizedBox(height: 12.h),

            TextField(
              controller: _notesController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: AppStrings.adminExpenseNotesHint,
                border: const OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12.h),

            // Receipt image picker
            InkWell(
              onTap: _pickImage,
              child: Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.attach_file, color: AppColors.primary),
                    SizedBox(width: 8.w),
                    Text(
                      _receiptImage != null
                          ? AppStrings.adminExpenseReceiptSelected
                          : AppStrings.adminExpenseAttachReceipt,
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),

            AppButton(
              text: AppStrings.adminSaveExpense,
              onPressed: _submit,
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
