import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fosha_app/core/constants/app_colors.dart';
import 'package:fosha_app/core/di/service_locator.dart';
import 'package:fosha_app/core/network/api_endpoints.dart';
import 'package:fosha_app/core/shared/widgets/app_button.dart';
import 'package:fosha_app/core/shared/widgets/app_loading.dart';
import 'package:fosha_app/core/shared/widgets/app_network_image.dart';
import 'package:fosha_app/core/shared/widgets/app_snackbar.dart';
import 'package:fosha_app/core/theme/app_text_styles.dart';
import 'package:fosha_app/features/admin/expenses/data/models/expense_model.dart';
import 'package:fosha_app/features/admin/expenses/presentation/cubit/admin_expenses_cubit.dart';
import 'package:fosha_app/features/admin/trips/data/models/trip_model.dart';
import 'package:fosha_app/features/admin/trips/data/repositories/admin_trips_repository.dart';

class AdminExpensesPage extends StatefulWidget {
  const AdminExpensesPage({super.key});

  @override
  State<AdminExpensesPage> createState() => _AdminExpensesPageState();
}

class _AdminExpensesPageState extends State<AdminExpensesPage> {
  String _selectedCategory = 'all';
  String _selectedTripId = 'all';
  List<TripModel> _trips = [];

  final Map<String, String> _categoriesMap = {
    'all': 'الكل',
    'hotel': 'فنادق وإقامة',
    'transportation': 'انتقالات وأتوبيسات',
    'food': 'وجبات ومشروبات',
    'activities': 'أنشطة وتذاكر',
    'staff': 'أجور ورواتب',
    'other': 'مصروفات أخرى',
  };

  @override
  void initState() {
    super.initState();
    _loadTrips();
    context.read<AdminExpensesCubit>().fetchExpenses();
  }

  Future<void> _loadTrips() async {
    try {
      final repo = getIt<AdminTripsRepository>();
      final result = await repo.getTrips(page: 1, limit: 50);
      result.fold(
        (_) {},
        (paginatedTrips) {
          if (mounted) {
            setState(() {
              _trips = paginatedTrips.trips;
            });
          }
        },
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        title: Text(
          'إدارة المصروفات',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddExpenseSheet(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('إضافة مصروف', style: TextStyle(color: Colors.white)),
      ),
      body: BlocConsumer<AdminExpensesCubit, AdminExpensesState>(
        listener: (context, state) {
          if (state is AdminExpenseActionSuccess) {
            AppSnackbar.showSuccess(context: context, message: state.message);
          } else if (state is AdminExpensesError) {
            AppSnackbar.showError(context: context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is AdminExpensesLoading) {
            return const Center(child: AppLoading());
          }

          if (state is AdminExpensesError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: AppColors.error),
              ),
            );
          }

          if (state is AdminExpensesLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                await context.read<AdminExpensesCubit>().fetchExpenses(
                      category: _selectedCategory,
                      tripId: _selectedTripId,
                    );
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Total Expenses Header Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.r),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE53935), Color(0xFFD32F2F)],
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'إجمالي المصروفات',
                            style: AppTextStyles.labelMedium
                                .copyWith(color: Colors.white70),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            '${state.totalAmount.toStringAsFixed(0)} ج.م',
                            style: AppTextStyles.headlineMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'عدد البنود المسجلة: ${state.expenses.length}',
                            style: AppTextStyles.labelSmall
                                .copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Filter Bar (Category Filter Chips)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _categoriesMap.entries.map((entry) {
                          final isSelected = _selectedCategory == entry.key;
                          return Padding(
                            padding: EdgeInsets.only(left: 8.w),
                            child: ChoiceChip(
                              label: Text(entry.value),
                              selected: isSelected,
                              selectedColor: AppColors.primary,
                              labelStyle: TextStyle(
                                color:
                                    isSelected ? Colors.white : AppColors.textPrimary,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() => _selectedCategory = entry.key);
                                  context.read<AdminExpensesCubit>().fetchExpenses(
                                        category: entry.key,
                                        tripId: _selectedTripId,
                                      );
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Expense Items List
                    if (state.expenses.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 40.h),
                        child: Center(
                          child: Text(
                            'لا توجد مصروفات مسجلة حالياً',
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.expenses.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final expense = state.expenses[index];
                          return _buildExpenseCard(expense);
                        },
                      ),
                    SizedBox(height: 80.h), // spacing for FAB
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildExpenseCard(ExpenseModel expense) {
    final categoryName = _categoriesMap[expense.category] ?? expense.category;
    IconData categoryIcon;
    switch (expense.category) {
      case 'hotel':
        categoryIcon = Icons.hotel;
        break;
      case 'transportation':
        categoryIcon = Icons.directions_bus;
        break;
      case 'food':
        categoryIcon = Icons.restaurant;
        break;
      case 'activities':
        categoryIcon = Icons.local_activity;
        break;
      case 'staff':
        categoryIcon = Icons.people;
        break;
      default:
        categoryIcon = Icons.receipt_long;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(categoryIcon, color: Colors.red, size: 24.r),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.title,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        categoryName,
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${expense.amount.toStringAsFixed(0)} ج.م',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (expense.tripTitle != null && expense.tripTitle!.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Row(
                children: [
                  const Icon(Icons.explore_outlined,
                      size: 16, color: AppColors.primary),
                  SizedBox(width: 4.w),
                  Text(
                    'مرتبط برحلة: ${expense.tripTitle}',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.primaryDark),
                  ),
                ],
              ),
            ],
            if (expense.notes.isNotEmpty) ...[
              SizedBox(height: 6.h),
              Text(
                'ملاحظات: ${expense.notes}',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (expense.receiptImage != null &&
                    expense.receiptImage!.isNotEmpty)
                  InkWell(
                    onTap: () => _showReceiptPreview(
                        context, ApiEndpoints.getImageUrl(expense.receiptImage)),
                    child: Row(
                      children: [
                        const Icon(Icons.image, size: 16, color: Colors.blue),
                        SizedBox(width: 4.w),
                        Text(
                          'عرض الإيصال',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12.sp,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const SizedBox.shrink(),
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: AppColors.error, size: 20),
                  onPressed: () => _confirmDeleteExpense(context, expense.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showReceiptPreview(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text('صورة الإيصال/الفاتورة'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
            AppNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              height: 350.h,
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteExpense(BuildContext context, String expenseId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('حذف المصروف'),
        content: const Text('هل أنت أؤكد من حذف بند المصروف هذا؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AdminExpensesCubit>().deleteExpense(
                    expenseId,
                    category: _selectedCategory,
                    tripId: _selectedTripId,
                  );
            },
            child: const Text('حذف', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showAddExpenseSheet(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    final notesController = TextEditingController();
    String category = 'hotel';
    String? selectedTrip;
    File? receiptImage;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
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
                      'إضافة بند مصروف جديد',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'عنوان المصروف (مثلاً: حجز الفندق)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'المبلغ الإجمالي (ج.م)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Category Selector
                  Text('الفئة:', style: AppTextStyles.labelLarge),
                  SizedBox(height: 6.h),
                  DropdownButtonFormField<String>(
                    value: category,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    items: [
                      'hotel',
                      'transportation',
                      'food',
                      'activities',
                      'staff',
                      'other'
                    ].map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(_categoriesMap[cat] ?? cat),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => category = val);
                    },
                  ),
                  SizedBox(height: 12.h),

                  // Trip Selector
                  Text('ربط بالرحلة (اختياري):', style: AppTextStyles.labelLarge),
                  SizedBox(height: 6.h),
                  DropdownButtonFormField<String?>(
                    value: selectedTrip,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('بدون ربط برحلة'),
                      ),
                      ..._trips.map((trip) => DropdownMenuItem(
                            value: trip.id,
                            child: Text(trip.title),
                          )),
                    ],
                    onChanged: (val) => setModalState(() => selectedTrip = val),
                  ),
                  SizedBox(height: 12.h),

                  TextField(
                    controller: notesController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'ملاحظات إضافية...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Receipt image picker
                  InkWell(
                    onTap: () async {
                      final picker = ImagePicker();
                      final picked = await picker.pickImage(
                          source: ImageSource.gallery);
                      if (picked != null) {
                        setModalState(() => receiptImage = File(picked.path));
                      }
                    },
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
                            receiptImage != null
                                ? 'تم اختيار الفاتورة'
                                : 'إرفاق صورة الفاتورة / الإيصال',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  AppButton(
                    text: 'حفظ المصروف',
                    onPressed: () {
                      if (titleController.text.trim().isEmpty ||
                          amountController.text.trim().isEmpty) {
                        AppSnackbar.showError(
                          context: context,
                          message: 'يرجى ملء كافة البيانات المطلوبة',
                        );
                        return;
                      }

                      final amount =
                          double.tryParse(amountController.text.trim()) ?? 0.0;

                      Navigator.pop(sheetContext);
                      context.read<AdminExpensesCubit>().addExpense(
                            title: titleController.text.trim(),
                            amount: amount,
                            category: category,
                            tripId: selectedTrip,
                            notes: notesController.text.trim(),
                            receiptImageFile: receiptImage?.path,
                          );
                    },
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
