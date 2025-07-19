import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/pharmacy_repository.dart';
import '../../data/entity/pharmacy_user.dart';

part 'pharmacy_register_state.dart';

class PharmacyRegisterCubit extends Cubit<PharmacyRegisterState> {
  final PharmacyRepository _repository;

  PharmacyRegisterCubit(this._repository) : super(PharmacyRegisterInitial());

  Future<void> register({
    required String fullname,
    required String email,
    required String password,
  }) async {
    emit(PharmacyRegisterLoading());

    try {
      final user = PharmacyUser(fullname: fullname, email: email);
      await _repository.registerPharmacyUser(user, password);
      emit(PharmacyRegisterSuccess());
    } catch (e) {
      emit(PharmacyRegisterFailure(message: e.toString()));
    }
  }
}
