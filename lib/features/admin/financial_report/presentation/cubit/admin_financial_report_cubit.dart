import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fosha_app/features/admin/financial_report/data/repositories/admin_financial_report_repository.dart';
import 'admin_financial_report_state.dart';
export 'admin_financial_report_state.dart';

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

    final result = await _repository.getFinancialReport(
      startDate: startDate,
      endDate: endDate,
      month: month,
      year: year,
    );

    result.fold(
      (failure) => emit(AdminFinancialReportError(failure.message)),
      (report) => emit(AdminFinancialReportLoaded(report)),
    );
  }
}
