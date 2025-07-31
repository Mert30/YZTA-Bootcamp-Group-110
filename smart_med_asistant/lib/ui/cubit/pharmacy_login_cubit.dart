import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Geçersiz e-posta adresi.';
          break;
        case 'user-disabled':
          errorMessage = 'Bu kullanıcı devre dışı bırakılmış.';
          break;
        case 'user-not-found':
          errorMessage =
              'Kullanıcı bulunamadı. E-posta adresinizi kontrol edin.';
          break;
        case 'wrong-password':
          errorMessage = 'Şifre yanlış. Lütfen tekrar deneyin.';
          break;
        default:
          errorMessage =
              'Bir hata oluştu. Lütfen bilgilerinizi kontrol ediniz.';
      }
      emit(PharmacyLoginFailure(message: errorMessage));
    } catch (_) {
      emit(
        PharmacyLoginFailure(
          message: 'Bilinmeyen bir hata oluştu. Lütfen tekrar deneyin.',
        ),
      );
    }
  }
}
