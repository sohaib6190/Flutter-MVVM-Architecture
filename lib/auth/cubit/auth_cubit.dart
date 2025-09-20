import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '../../utils/utils.dart';
import '../auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authenticationRepository) : super(const AuthState());

  final AuthenticationRepository authenticationRepository;
  Timer? _timer;

  void currentPageChanged() {
    emit(state.copyWith(
      isCurrentPageLogin: !state.isCurrentPageLogin,
    ));
  }

  void loginEmailChanged(String email) {
    final dirtyEmail = InvalidValidationInput.dirty(emailPattern, email);

    emit(state.copyWith(
      loginEmail: dirtyEmail,
      isLoginValid: Formz.validate([
        dirtyEmail,
        state.loginPassword,
      ]),
    ));
  }

  void loginPasswordChanged(String password) {
    final dirtyPassword = EmptyValidationInput.dirty(password);

    emit(state.copyWith(
      loginPassword: dirtyPassword,
      isLoginValid: Formz.validate([
        state.loginEmail,
        dirtyPassword,
      ]),
    ));
  }

  void loginPasswordObscureChanged() {
    emit(state.copyWith(
      isLoginPasswordObscure: !state.isLoginPasswordObscure,
    ));
  }

  Future<void> login() async {
    if (state.isLoginValid) {
      emit(state.copyWith(
        loginStatus:
            const GeneralApiState<void>(apiCallState: APICallState.loading),
        registerStatus: const GeneralApiState<void>(),
      ));
      await authenticationRepository
          .login(
        state.loginEmail.value,
        state.loginPassword.value,
        fcmService.getfcmToken(),
      )
          .then((_) {
        emit(state.copyWith(
          loginStatus:
              const GeneralApiState<void>(apiCallState: APICallState.loaded),
        ));
      }).catchError((e) {
        if (e is String) {
          emit(state.copyWith(
            loginStatus: GeneralApiState<void>(
                apiCallState: APICallState.failure, errorMessage: e),
          ));
        } else {
          emit(state.copyWith(
            loginStatus:
                const GeneralApiState<void>(apiCallState: APICallState.failure),
          ));
        }
      });
    } else {
      const invalidEmail = InvalidValidationInput.dirty(emailPattern, '');
      const invalidPassword = EmptyValidationInput.dirty('');

      emit(state.copyWith(
        loginEmail: state.loginEmail.isPure ? invalidEmail : state.loginEmail,
        loginPassword:
            state.loginPassword.isPure ? invalidPassword : state.loginPassword,
      ));
    }
  }

  Future<void> registerPhotoChanged() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      final photoPath = result.files.first.path!;

      final dirtyPhoto = EmptyValidationInput.dirty(photoPath);

      emit(state.copyWith(
        registerPhoto: dirtyPhoto,
        isRegisterValid: Formz.validate([
          dirtyPhoto,
          state.registerName,
          state.registerEmail,
          state.registerUsername,
          state.registerDOB,
          state.registerPassword,
          state.registerConfirmPassword,
        ]),
      ));
    }
  }

  void registerNameChanged(String name) {
    final dirtyName = InvalidValidationInput.dirty(namePattern, name);

    emit(state.copyWith(
      registerName: dirtyName,
      isRegisterValid: Formz.validate([
        state.registerPhoto,
        dirtyName,
        state.registerEmail,
        state.registerUsername,
        state.registerDOB,
        state.registerPassword,
        state.registerConfirmPassword,
      ]),
    ));
  }

  void registerEmailChanged(String email) {
    final dirtyEmail = InvalidValidationInput.dirty(emailPattern, email);

    emit(state.copyWith(
      registerEmail: dirtyEmail,
      isRegisterValid: Formz.validate([
        state.registerPhoto,
        state.registerName,
        dirtyEmail,
        state.registerUsername,
        state.registerDOB,
        state.registerPassword,
        state.registerConfirmPassword,
      ]),
    ));
  }

  void registerUsernameChanged(String username) {
    final dirtyUsername =
        InvalidValidationInput.dirty(usernamePattern, username);

    emit(state.copyWith(
      registerUsername: dirtyUsername,
      isRegisterValid: Formz.validate([
        state.registerPhoto,
        state.registerName,
        state.registerEmail,
        dirtyUsername,
        state.registerDOB,
        state.registerPassword,
        state.registerConfirmPassword,
      ]),
    ));
  }

  void registerDOBChanged(String dOB) {
    final dirtyDOB = EmptyValidationInput.dirty(dOB);

    emit(state.copyWith(
      registerDOB: dirtyDOB,
      isRegisterValid: Formz.validate([
        state.registerPhoto,
        state.registerName,
        state.registerEmail,
        state.registerUsername,
        dirtyDOB,
        state.registerPassword,
        state.registerConfirmPassword,
      ]),
    ));
  }

  void registerPasswordChanged(String password) {
    final dirtyPassword =
        InvalidValidationInput.dirty(passwordPattern, password);

    emit(state.copyWith(
      registerPassword: dirtyPassword,
      isRegisterValid: Formz.validate([
        state.registerPhoto,
        state.registerName,
        state.registerEmail,
        state.registerUsername,
        state.registerDOB,
        dirtyPassword,
        state.registerConfirmPassword,
      ]),
    ));
  }

  void registerPasswordObscureChanged() {
    emit(state.copyWith(
      isRegisterPasswordObscure: !state.isRegisterPasswordObscure,
    ));
  }

  void registerConfirmPasswordChanged(String confirmPassword) {
    final dirtyConfirmPassword = MismatchValidationInput.dirty(
        state.registerPassword.value, confirmPassword);

    emit(state.copyWith(
      registerConfirmPassword: dirtyConfirmPassword,
      isRegisterValid: Formz.validate([
        state.registerPhoto,
        state.registerName,
        state.registerEmail,
        state.registerUsername,
        state.registerDOB,
        state.registerPassword,
        dirtyConfirmPassword,
      ]),
    ));
  }

  void registerConfrimPasswordObscureChanged() {
    emit(state.copyWith(
      isRegisterConfirmPasswordObscure: !state.isRegisterConfirmPasswordObscure,
    ));
  }

  Future<void> register() async {
    if (state.isRegisterValid) {
      emit(state.copyWith(
        registerException: const AuthExceptionModel(),
        registerStatus:
            const GeneralApiState<void>(apiCallState: APICallState.loading),
        loginStatus: const GeneralApiState<void>(),
      ));
      await authenticationRepository
          .register(
        state.registerPhoto.value,
        state.registerName.value,
        state.registerEmail.value,
        state.registerUsername.value,
        state.registerDOB.value,
        state.registerPassword.value,
        state.registerConfirmPassword.value,
        fcmService.getfcmToken(),
      )
          .then((_) {
        emit(state.copyWith(
          registerStatus:
              const GeneralApiState<void>(apiCallState: APICallState.loaded),
        ));
      }).catchError((e) {
        if (e is Map<String, dynamic>) {
          emit(state.copyWith(
            registerStatus:
                const GeneralApiState<void>(apiCallState: APICallState.failure),
            registerException: AuthExceptionModel.fromJson(e),
          ));
        } else if (e is String) {
          emit(state.copyWith(
            registerStatus: GeneralApiState<void>(
                apiCallState: APICallState.failure, errorMessage: e),
          ));
        } else {
          emit(state.copyWith(
            registerStatus:
                const GeneralApiState<void>(apiCallState: APICallState.failure),
          ));
        }
      });
    } else {
      const invalidPhoto = EmptyValidationInput.dirty('');
      const invalidName = InvalidValidationInput.dirty(namePattern, '');
      const invalidEmail = InvalidValidationInput.dirty(emailPattern, '');
      const invalidUsername = InvalidValidationInput.dirty(usernamePattern, '');
      const invalidDOB = EmptyValidationInput.dirty('');
      const invalidPassword = InvalidValidationInput.dirty(passwordPattern, '');
      final invalidConfirmPassword =
          MismatchValidationInput.dirty(state.registerPassword.value, '');

      emit(state.copyWith(
        registerPhoto:
            state.registerPhoto.isPure ? invalidPhoto : state.registerPhoto,
        registerName:
            state.registerName.isPure ? invalidName : state.registerName,
        registerEmail:
            state.registerEmail.isPure ? invalidEmail : state.registerEmail,
        registerUsername: state.registerUsername.isPure
            ? invalidUsername
            : state.registerUsername,
        registerDOB: state.registerDOB.isPure ? invalidDOB : state.registerDOB,
        registerPassword: state.registerPassword.isPure
            ? invalidPassword
            : state.registerPassword,
        registerConfirmPassword: state.registerConfirmPassword.isPure
            ? invalidConfirmPassword
            : state.registerConfirmPassword,
      ));
    }
  }

  void forgotPasswordEmailChanged(String email) {
    final dirtyEmail = InvalidValidationInput.dirty(emailPattern, email);

    emit(state.copyWith(
      forgotPasswordEmail: dirtyEmail,
      isForgotPasswordEmailValid: Formz.validate([dirtyEmail]),
    ));
  }

  Future<void> forgotPasswordEmailSent() async {
    if (state.isForgotPasswordEmailValid) {
      emit(state.copyWith(
        forgotPasswordEmailStatus: FormzSubmissionStatus.inProgress,
      ));
      await authenticationRepository
          .forgotPasswordEmailSent(state.forgotPasswordEmail.value)
          .then((_) {
        emit(state.copyWith(
          forgotPasswordEmailStatus: FormzSubmissionStatus.success,
        ));
      }).catchError((e) {
        if (e is Map<String, dynamic>) {
          emit(state.copyWith(
            forgotPasswordEmailStatus: FormzSubmissionStatus.failure,
            forgotPasswordException: AuthExceptionModel.fromJson(e),
          ));
        } else {
          emit(state.copyWith(
            forgotPasswordEmailStatus: FormzSubmissionStatus.failure,
          ));
        }
      });
    } else {
      const invalidEmail = InvalidValidationInput.dirty(emailPattern, '');

      emit(state.copyWith(
        forgotPasswordEmail: state.forgotPasswordEmail.isPure
            ? invalidEmail
            : state.forgotPasswordEmail,
      ));
    }
  }

  Future<void> forgotPasswordResendOTP() async {
    if (state.isForgotPasswordEmailValid) {
      emit(state.copyWith(
        forgotPasswordResendOTPStatus: FormzSubmissionStatus.inProgress,
        forgotPasswordOTPStatus: FormzSubmissionStatus.initial,
      ));
      await authenticationRepository
          .forgotPasswordEmailSent(state.forgotPasswordEmail.value)
          .then((_) {
        emit(state.copyWith(
          forgotPasswordResendOTPStatus: FormzSubmissionStatus.success,
        ));
      }).catchError((_) {
        emit(state.copyWith(
          forgotPasswordResendOTPStatus: FormzSubmissionStatus.failure,
        ));
      });
    } else {
      const invalidEmail = InvalidValidationInput.dirty(emailPattern, '');

      emit(state.copyWith(
        forgotPasswordEmail: state.forgotPasswordEmail.isPure
            ? invalidEmail
            : state.forgotPasswordEmail,
      ));
    }
  }

  void forgotPasswordStartTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }

    emit(state.copyWith(
        forgotPasswordOTPTimeLeft: 90, isForgotPasswordOTPTimeFinished: false));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.forgotPasswordOTPTimeLeft > 0) {
        emit(state.copyWith(
            forgotPasswordOTPTimeLeft: state.forgotPasswordOTPTimeLeft - 1));
      } else {
        _timer?.cancel();
        emit(state.copyWith(isForgotPasswordOTPTimeFinished: true));
      }
    });
  }

  void forgotPasswordCancelTimer() {
    _timer?.cancel();
    emit(state.copyWith(
        forgotPasswordOTPTimeLeft: 90, isForgotPasswordOTPTimeFinished: false));
  }

  void forgotPasswordOtpChanged(String otp) {
    final dirtyOTP = InvalidValidationInput.dirty(fourLimitPattern, otp);

    emit(state.copyWith(
      forgotPasswordOTP: dirtyOTP,
      isForgotPasswordOTPValid: Formz.validate([dirtyOTP]),
    ));
  }

  Future<void> forgotPasswordOtpVerified() async {
    if (state.isForgotPasswordOTPValid) {
      emit(state.copyWith(
        forgotPasswordResendOTPStatus: FormzSubmissionStatus.initial,
        forgotPasswordOTPStatus: FormzSubmissionStatus.inProgress,
      ));
      await authenticationRepository
          .forgotPasswordOtpVerified(state.forgotPasswordEmail.value,
              int.parse(state.forgotPasswordOTP.value))
          .then((_) {
        emit(state.copyWith(
          forgotPasswordOTPStatus: FormzSubmissionStatus.success,
        ));
      }).catchError((e) {
        emit(state.copyWith(
          forgotPasswordOTPStatus: FormzSubmissionStatus.failure,
          otpErrorMessage: e.toString(),
        ));
      });
    }
  }

  void forgotPasswordPasswordChanged(String password) {
    final dirtyPassword =
        InvalidValidationInput.dirty(passwordPattern, password);

    emit(state.copyWith(
      forgotPasswordPassword: dirtyPassword,
      isForgotPasswordPasswordValid: Formz.validate([
        dirtyPassword,
        state.forgotPasswordConfirmPassword,
      ]),
    ));
  }

  void forgotPasswordPasswordObscureChanged() {
    emit(state.copyWith(
      isForgotPasswordPasswordObscure: !state.isForgotPasswordPasswordObscure,
    ));
  }

  void forgotPasswordConfirmPasswordChanged(String confirmPassword) {
    final dirtyConfirmPassword = MismatchValidationInput.dirty(
        state.forgotPasswordPassword.value, confirmPassword);

    emit(state.copyWith(
      forgotPasswordConfirmPassword: dirtyConfirmPassword,
      isForgotPasswordPasswordValid: Formz.validate([
        state.forgotPasswordPassword,
        dirtyConfirmPassword,
      ]),
    ));
  }

  void forgotPasswordConfirmPasswordObscureChanged() {
    emit(state.copyWith(
      isForgotPasswordConfirmPasswordObscure:
          !state.isForgotPasswordConfirmPasswordObscure,
    ));
  }

  Future<void> forgotPassword() async {
    if (state.isForgotPasswordPasswordValid) {
      emit(state.copyWith(
        forgotPasswordPasswordStatus: FormzSubmissionStatus.inProgress,
      ));
      await authenticationRepository
          .forgotPassword(
              state.forgotPasswordEmail.value,
              state.forgotPasswordPassword.value,
              state.forgotPasswordConfirmPassword.value)
          .then((_) {
        emit(state.copyWith(
          forgotPasswordPasswordStatus: FormzSubmissionStatus.success,
        ));
      }).catchError((_) {
        emit(state.copyWith(
          forgotPasswordPasswordStatus: FormzSubmissionStatus.failure,
        ));
      });
    } else {
      const invalidPassword = InvalidValidationInput.dirty(passwordPattern, '');
      final invalidConfirmPassword =
          MismatchValidationInput.dirty(state.forgotPasswordPassword.value, '');

      emit(state.copyWith(
        forgotPasswordPassword: state.forgotPasswordPassword.isPure
            ? invalidPassword
            : state.forgotPasswordPassword,
        forgotPasswordConfirmPassword:
            state.forgotPasswordConfirmPassword.isPure
                ? invalidConfirmPassword
                : state.forgotPasswordConfirmPassword,
      ));
    }
  }

  Future<void> signInWithApple() async {
    emit(state.copyWith(
      loginStatus:
          const GeneralApiState<void>(apiCallState: APICallState.loading),
    ));
    await authenticationRepository
        .signInWithApple(fcmService.getfcmToken())
        .then((_) {
      emit(state.copyWith(
        loginStatus:
            const GeneralApiState<void>(apiCallState: APICallState.loaded),
      ));
    }).catchError((_) {
      emit(state.copyWith(
        loginStatus:
            const GeneralApiState<void>(apiCallState: APICallState.failure),
      ));
    });
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(
      loginStatus:
          const GeneralApiState<void>(apiCallState: APICallState.loading),
    ));
    await authenticationRepository
        .signInWithGoogle(fcmService.getfcmToken())
        .then((_) {
      emit(state.copyWith(
        loginStatus:
            const GeneralApiState<void>(apiCallState: APICallState.loaded),
      ));
    }).catchError((_) {
      emit(state.copyWith(
        loginStatus:
            const GeneralApiState<void>(apiCallState: APICallState.failure),
      ));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
