import 'package:dio/dio.dart';
import 'package:fosha_app/core/network/api_endpoints.dart';
import 'package:fosha_app/core/network/dio_client.dart';
import '../models/expense_model.dart';

abstract class AdminExpensesRemoteDataSource {
  Future<List<ExpenseModel>> getExpenses({
    String? tripId,
    String? category,
    String? startDate,
    String? endDate,
  });

  Future<List<ExpenseCategorySummaryModel>> getExpensesSummary();

  Future<ExpenseModel> addExpense({
    required String title,
    required double amount,
    required String category,
    String? tripId,
    String? expenseDate,
    String? notes,
    dynamic receiptImageFile, // String path or File
  });

  Future<ExpenseModel> updateExpense({
    required String expenseId,
    required String title,
    required double amount,
    required String category,
    String? tripId,
    String? expenseDate,
    String? notes,
    dynamic receiptImageFile,
  });

  Future<void> deleteExpense(String expenseId);
}

class AdminExpensesRemoteDataSourceImpl
    implements AdminExpensesRemoteDataSource {
  final DioClient _dioClient;

  AdminExpensesRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<ExpenseModel>> getExpenses({
    String? tripId,
    String? category,
    String? startDate,
    String? endDate,
  }) async {
    final queryParams = <String, dynamic>{};
    if (tripId != null && tripId.isNotEmpty && tripId != 'all') {
      queryParams['tripId'] = tripId;
    }
    if (category != null && category.isNotEmpty && category != 'all') {
      queryParams['category'] = category;
    }
    if (startDate != null && startDate.isNotEmpty) {
      queryParams['startDate'] = startDate;
    }
    if (endDate != null && endDate.isNotEmpty) {
      queryParams['endDate'] = endDate;
    }

    final response = await _dioClient.dio.get(
      ApiEndpoints.expenses,
      queryParameters: queryParams,
    );

    final resModel = ExpenseListResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
    return resModel.expenses;
  }

  @override
  Future<List<ExpenseCategorySummaryModel>> getExpensesSummary() async {
    final response = await _dioClient.dio.get(ApiEndpoints.expensesSummary);
    final resModel = ExpenseSummaryResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
    return resModel.byCategory;
  }

  @override
  Future<ExpenseModel> addExpense({
    required String title,
    required double amount,
    required String category,
    String? tripId,
    String? expenseDate,
    String? notes,
    dynamic receiptImageFile,
  }) async {
    final formDataMap = <String, dynamic>{
      'title': title,
      'amount': amount,
      'category': category,
      if (tripId != null && tripId.isNotEmpty) 'tripId': tripId,
      if (expenseDate != null && expenseDate.isNotEmpty)
        'expenseDate': expenseDate,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    };

    if (receiptImageFile != null) {
      if (receiptImageFile is String && receiptImageFile.isNotEmpty) {
        formDataMap['receiptImage'] = await MultipartFile.fromFile(
          receiptImageFile,
        );
      }
    }

    final formData = FormData.fromMap(formDataMap);
    final response = await _dioClient.dio.post(
      ApiEndpoints.expenses,
      data: formData,
    );

    final rawData = response.data;
    final json = (rawData is Map<String, dynamic> && rawData['data'] != null)
        ? rawData['data'] as Map<String, dynamic>
        : rawData as Map<String, dynamic>;

    return ExpenseModel.fromJson(json);
  }

  @override
  Future<ExpenseModel> updateExpense({
    required String expenseId,
    required String title,
    required double amount,
    required String category,
    String? tripId,
    String? expenseDate,
    String? notes,
    dynamic receiptImageFile,
  }) async {
    final formDataMap = <String, dynamic>{
      'title': title,
      'amount': amount,
      'category': category,
      if (tripId != null && tripId.isNotEmpty) 'tripId': tripId,
      if (expenseDate != null && expenseDate.isNotEmpty)
        'expenseDate': expenseDate,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    };

    if (receiptImageFile != null && receiptImageFile is String) {
      formDataMap['receiptImage'] = await MultipartFile.fromFile(
        receiptImageFile,
      );
    }

    final formData = FormData.fromMap(formDataMap);
    final response = await _dioClient.dio.put(
      '${ApiEndpoints.expenses}/$expenseId',
      data: formData,
    );

    final rawData = response.data;
    final json = (rawData is Map<String, dynamic> && rawData['data'] != null)
        ? rawData['data'] as Map<String, dynamic>
        : rawData as Map<String, dynamic>;

    return ExpenseModel.fromJson(json);
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    await _dioClient.dio.delete('${ApiEndpoints.expenses}/$expenseId');
  }
}
