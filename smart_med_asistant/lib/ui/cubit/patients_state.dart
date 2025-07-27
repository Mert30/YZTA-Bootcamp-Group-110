part of 'patients_cubit.dart';

@immutable
abstract class PatientsState {}

class PatientsInitial extends PatientsState {}

class PatientsLoading extends PatientsState {}

class PatientsLoaded extends PatientsState {
  final List<Map<String, dynamic>> patients;

  PatientsLoaded(this.patients);
}

class PatientsError extends PatientsState {
  final String message;

  PatientsError(this.message);
}
