part of 'patient_prescriptions_cubit.dart';

abstract class PatientPrescriptionsState {}

class PatientPrescriptionsInitial extends PatientPrescriptionsState {}

class PatientPrescriptionsLoading extends PatientPrescriptionsState {}

class PatientPrescriptionsLoaded extends PatientPrescriptionsState {
  final List<Prescription> prescriptions;
  final String? interactionAnalysis; 

  PatientPrescriptionsLoaded(this.prescriptions, {this.interactionAnalysis});
}

class PatientPrescriptionsError extends PatientPrescriptionsState {
  final String message;

  PatientPrescriptionsError(this.message);
}
