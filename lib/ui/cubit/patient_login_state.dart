part of 'patient_login_cubit.dart';

abstract class PatientLoginState {}

class PatientLoginInitial extends PatientLoginState {}

class PatientLoginLoading extends PatientLoginState {}

class PatientLoginSuccess extends PatientLoginState {}

class PatientLoginFailure extends PatientLoginState {
  final String error;
  PatientLoginFailure({required this.error});
}
