part of 'pharmacy_login_cubit.dart';

abstract class PharmacyLoginState {}

class PharmacyLoginInitial extends PharmacyLoginState {}

class PharmacyLoginLoading extends PharmacyLoginState {}

class PharmacyLoginSuccess extends PharmacyLoginState {}

class PharmacyLoginFailure extends PharmacyLoginState {
  final String message;
  PharmacyLoginFailure({required this.message});
}
