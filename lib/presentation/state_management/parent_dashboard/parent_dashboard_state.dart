import '../../../domain/entities/parent_dashboard_entity.dart';

abstract class ParentDashboardState {}

class ParentDashboardInitial extends ParentDashboardState {}

class ParentDashboardLoading extends ParentDashboardState {}

class ParentDashboardLoaded extends ParentDashboardState {
  final ParentDashboardEntity dashboard;
  ParentDashboardLoaded(this.dashboard);
}

class ParentDashboardError extends ParentDashboardState {
  final String message;
  ParentDashboardError(this.message);
}
