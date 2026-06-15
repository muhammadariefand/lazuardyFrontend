import 'package:lazuadry_mobile_fe/domain/entities/tutor_dashboard_entity.dart';

abstract class TutorDashboardState {}

class TutorDashboardInitial extends TutorDashboardState {}

class TutorDashboardLoading extends TutorDashboardState {}

class TutorDashboardLoaded extends TutorDashboardState {
  final TutorDashboardEntity dashboardData;

  TutorDashboardLoaded(this.dashboardData);
}

class TutorDashboardError extends TutorDashboardState {
  final String message;

  TutorDashboardError(this.message);
}
