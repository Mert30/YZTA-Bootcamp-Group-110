part of 'patient_prescriptions_cubit.dart';

abstract class PatientPrescriptionsState {}

class PatientPrescriptionsInitial extends PatientPrescriptionsState {}

class PatientPrescriptionsLoading extends PatientPrescriptionsState {}

class PatientPrescriptionsLoaded extends PatientPrescriptionsState {
  final List<Prescription> prescriptions;

  PatientPrescriptionsLoaded(this.prescriptions);
}

class PatientPrescriptionsError extends PatientPrescriptionsState {
  final String message;

  PatientPrescriptionsError(this.message);
}
