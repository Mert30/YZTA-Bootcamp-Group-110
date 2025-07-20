part of 'add_medicine_cubit.dart';

abstract class AddMedicineState {}

class AddMedicineInitial extends AddMedicineState {}

class AddMedicineLoading extends AddMedicineState {}

class AddMedicineSuccess extends AddMedicineState {}

class AddMedicineFailure extends AddMedicineState {
  final String message;
  AddMedicineFailure({required this.message});
}

class AddMedicineAIResponse extends AddMedicineState {
  final String aiSummary;
  AddMedicineAIResponse(this.aiSummary);
}
