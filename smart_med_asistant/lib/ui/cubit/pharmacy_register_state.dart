part of 'pharmacy_register_cubit.dart';

abstract class PharmacyRegisterState {}

class PharmacyRegisterInitial extends PharmacyRegisterState {}

class PharmacyRegisterLoading extends PharmacyRegisterState {}

class PharmacyRegisterSuccess extends PharmacyRegisterState {}

class PharmacyRegisterFailure extends PharmacyRegisterState {
  final String message;
  PharmacyRegisterFailure({required this.message});
}
