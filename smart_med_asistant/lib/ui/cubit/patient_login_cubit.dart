import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_med_assistant/data/repo/patient_repository.dart';

part 'patient_login_state.dart';

class PatientLoginCubit extends Cubit<PatientLoginState> {
  final PatientRepository repository;

  PatientLoginCubit(this.repository) : super(PatientLoginInitial());

  Future<void> login({required String email, required String password}) async {
    emit(PatientLoginLoading());
    try {
      await repository.login(email: email, password: password);
      emit(PatientLoginSuccess());
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Bu e-posta ile kayıtlı bir kullanıcı bulunamadı.';
          break;
        case 'wrong-password':
          errorMessage = 'Şifre yanlış. Lütfen tekrar deneyin.';
          break;
        case 'invalid-email':
          errorMessage = 'Geçersiz e-posta adresi.';
          break;
        case 'user-disabled':
          errorMessage = 'Bu hesap devre dışı bırakılmış.';
          break;
        default:
          errorMessage =
              'Giriş başarısız. Lütfen bilgilerinizi kontrol ediniz.';
      }

      emit(PatientLoginFailure(error: errorMessage));
    } catch (e) {
      emit(PatientLoginFailure(error: 'Bilinmeyen bir hata oluştu.'));
    }
  }
}
