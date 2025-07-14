part of 'patient_register_cubit.dart';

abstract class PatientRegisterState {}

class PatientRegisterInitial extends PatientRegisterState {}

class PatientRegisterLoading extends PatientRegisterState {}

class PatientRegisterSuccess extends PatientRegisterState {}

class PatientRegisterFailure extends PatientRegisterState {
  final String error;
  PatientRegisterFailure({required this.error});
}
