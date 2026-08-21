import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/core/errors/api_error_handler.dart';
import 'package:fosha_app/features/admin/financial_report/data/models/financial_report_model.dart';
import 'package:fosha_app/features/admin/financial_report/data/repositories/admin_financial_report_repository.dart';

abstract class AdminFinancialReportState {}

class AdminFinancialReportInitial extends AdminFinancialReportState {}

class AdminFinancialReportLoading extends AdminFinancialReportState {}

class AdminFinancialReportLoaded extends AdminFinancialReportState {
  final FinancialReportModel report;
  AdminFinancialReportLoaded(this.report);
}

class AdminFinancialReportError extends AdminFinancialReportState {
  final String message;
  AdminFinancialReportError(this.message);
}

class AdminFinancialReportCubit extends Cubit<AdminFinancialReportState> {
  final AdminFinancialReportRepository _repository;

  AdminFinancialReportCubit(this._repository)
      : super(AdminFinancialReportInitial());

  Future<void> fetchFinancialReport({
    String? startDate,
    String? endDate,
    int? month,
    int? year,
  }) async {
    emit(AdminFinancialReportLoading());
    try {
      final report = await _repository.getFinancialReport(
        startDate: startDate,
        endDate: endDate,
        month: month,
        year: year,
      );
      emit(AdminFinancialReportLoaded(report));
    } catch (e) {
      emit(AdminFinancialReportError(ApiErrorHandler.handle(e)));
    }
  }
}
