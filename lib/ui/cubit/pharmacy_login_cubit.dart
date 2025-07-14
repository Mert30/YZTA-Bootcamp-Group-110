import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/pharmacy_repository.dart';

part 'pharmacy_login_state.dart';

class PharmacyLoginCubit extends Cubit<PharmacyLoginState> {
  final PharmacyRepository _repository;

  PharmacyLoginCubit(this._repository) : super(PharmacyLoginInitial());

  Future<void> login(String email, String password) async {
    emit(PharmacyLoginLoading());
    try {
      await _repository.loginPharmacyUser(email, password);
      emit(PharmacyLoginSuccess());
    } catch (e) {
      emit(PharmacyLoginFailure(message: e.toString()));
    }
  }
}
