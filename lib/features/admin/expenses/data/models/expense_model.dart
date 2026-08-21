class ExpenseCategorySummaryModel {
  final String category;
  final double totalAmount;
  final int count;

  const ExpenseCategorySummaryModel({
    required this.category,
    required this.totalAmount,
    required this.count,
  });

  factory ExpenseCategorySummaryModel.fromJson(Map<String, dynamic> json) {
    return ExpenseCategorySummaryModel(
      category: json['_id'] as String? ?? json['category'] as String? ?? 'other',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      count: (json['count'] as int?) ?? 0,
    );
  }
}

class ExpenseModel {
  final String id;
  final String title;
  final double amount;
  final String category;
  final String? tripId;
  final String? tripTitle;
  final String expenseDate;
  final String notes;
  final String? receiptImage;

  const ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    this.tripId,
    this.tripTitle,
    required this.expenseDate,
    required this.notes,
    this.receiptImage,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    String? tripT;
    String? tripI;
    if (json['trip'] != null) {
      if (json['trip'] is Map<String, dynamic>) {
        tripI = json['trip']['_id'] as String? ?? json['trip']['id'] as String?;
        tripT = json['trip']['title'] as String?;
      } else if (json['trip'] is String) {
        tripI = json['trip'] as String;
      }
    } else {
      tripI = json['tripId'] as String?;
    }

    return ExpenseModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] as String? ?? 'other',
      tripId: tripI,
      tripTitle: tripT,
      expenseDate: json['expenseDate'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      receiptImage: json['receiptImage'] as String?,
    );
  }
}

class ExpensesPaginationModel {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const ExpensesPaginationModel({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory ExpensesPaginationModel.fromJson(Map<String, dynamic> json) {
    return ExpensesPaginationModel(
      total: (json['total'] as int?) ?? 0,
      page: (json['page'] as int?) ?? 1,
      limit: (json['limit'] as int?) ?? 20,
      totalPages: (json['totalPages'] as int?) ?? 1,
    );
  }
}

class ExpenseListResponseModel {
  final List<ExpenseModel> expenses;
  final ExpensesPaginationModel? pagination;

  const ExpenseListResponseModel({
    required this.expenses,
    this.pagination,
  });

  factory ExpenseListResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    List<ExpenseModel> expList = [];
    if (data['expenses'] is List) {
      expList = (data['expenses'] as List<dynamic>)
          .map((e) => ExpenseModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (data['items'] is List) {
      expList = (data['items'] as List<dynamic>)
          .map((e) => ExpenseModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (json['data'] is List) {
      expList = (json['data'] as List<dynamic>)
          .map((e) => ExpenseModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final pagJson = data['pagination'] as Map<String, dynamic>?;

    return ExpenseListResponseModel(
      expenses: expList,
      pagination:
          pagJson != null ? ExpensesPaginationModel.fromJson(pagJson) : null,
    );
  }
}

class ExpenseSummaryResponseModel {
  final double totalExpenses;
  final List<ExpenseCategorySummaryModel> byCategory;

  const ExpenseSummaryResponseModel({
    required this.totalExpenses,
    required this.byCategory,
  });

  factory ExpenseSummaryResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final catList = (data['byCategory'] as List<dynamic>?)
            ?.map((e) =>
                ExpenseCategorySummaryModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final total = (data['totalExpenses'] as num?)?.toDouble() ?? 0.0;

    return ExpenseSummaryResponseModel(
      totalExpenses: total,
      byCategory: catList,
    );
  }
}
