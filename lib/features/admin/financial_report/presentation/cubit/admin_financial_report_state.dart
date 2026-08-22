import 'package:equatable/equatable.dart';
import 'package:fosha_app/features/admin/financial_report/data/models/financial_report_model.dart';

abstract class AdminFinancialReportState extends Equatable {
  const AdminFinancialReportState();

  @override
  List<Object?> get props => [];
}

class AdminFinancialReportInitial extends AdminFinancialReportState {}

class AdminFinancialReportLoading extends AdminFinancialReportState {}

class AdminFinancialReportLoaded extends AdminFinancialReportState {
  final FinancialReportModel report;

  const AdminFinancialReportLoaded(this.report);

  @override
  List<Object?> get props => [report];
}

class AdminFinancialReportError extends AdminFinancialReportState {
  final String message;

  const AdminFinancialReportError(this.message);

  @override
  List<Object?> get props => [message];
}
