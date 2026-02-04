part of 'auth_cubit.dart';

class AuthState extends Equatable {
  const AuthState({
    this.loginStatus = const GeneralApiState<void>(),
    this.loginEmail = const InvalidValidationInput.pure(emailPattern),
    this.loginPassword = const EmptyValidationInput.pure(),
    this.isLoginPasswordObscure = true,
    this.isLoginValid = false,
    this.registerStatus = const GeneralApiState<void>(),
    this.registerPhoto = const EmptyValidationInput.pure(),
    this.registerName = const InvalidValidationInput.pure(namePattern),
    this.registerEmail = const InvalidValidationInput.pure(emailPattern),
    this.registerUsername = const InvalidValidationInput.pure(usernamePattern),
    this.registerDOB = const EmptyValidationInput.pure(),
    this.registerPassword = const InvalidValidationInput.pure(passwordPattern),
    this.registerConfirmPassword = const MismatchValidationInput.pure(''),
    this.isRegisterPasswordObscure = true,
    this.isRegisterConfirmPasswordObscure = true,
    this.isRegisterValid = false,
    this.registerException = const AuthExceptionModel(),
    this.isCurrentPageLogin = true,
    this.forgotPasswordEmailStatus = FormzSubmissionStatus.initial,
    this.forgotPasswordEmail = const InvalidValidationInput.pure(emailPattern),
    this.isForgotPasswordEmailValid = false,
    this.forgotPasswordException = const AuthExceptionModel(),
    this.forgotPasswordResendOTPStatus = FormzSubmissionStatus.initial,
    this.forgotPasswordOTPStatus = FormzSubmissionStatus.initial,
    this.forgotPasswordOTPTimeLeft = 90,
    this.isForgotPasswordOTPTimeFinished = false,
    this.forgotPasswordOTP =
        const InvalidValidationInput.pure(fourLimitPattern),
    this.isForgotPasswordOTPValid = false,
    this.otpErrorMessage = '',
    this.forgotPasswordPasswordStatus = FormzSubmissionStatus.initial,
    this.forgotPasswordPassword =
        const InvalidValidationInput.pure(passwordPattern),
    this.forgotPasswordConfirmPassword = const MismatchValidationInput.pure(''),
    this.isForgotPasswordPasswordValid = false,
    this.isForgotPasswordPasswordObscure = true,
    this.isForgotPasswordConfirmPasswordObscure = true,
  });

  final GeneralApiState<void> loginStatus;
  final InvalidValidationInput loginEmail;
  final EmptyValidationInput loginPassword;
  final bool isLoginPasswordObscure;
  final bool isLoginValid;
  final GeneralApiState<void> registerStatus;
  final EmptyValidationInput registerPhoto;
  final InvalidValidationInput registerName;
  final InvalidValidationInput registerEmail;
  final InvalidValidationInput registerUsername;
  final EmptyValidationInput registerDOB;
  final InvalidValidationInput registerPassword;
  final MismatchValidationInput registerConfirmPassword;
  final bool isRegisterPasswordObscure;
  final bool isRegisterConfirmPasswordObscure;
  final bool isRegisterValid;
  final AuthExceptionModel registerException;
  final bool isCurrentPageLogin;
  final FormzSubmissionStatus forgotPasswordEmailStatus;
  final InvalidValidationInput forgotPasswordEmail;
  final bool isForgotPasswordEmailValid;
  final AuthExceptionModel forgotPasswordException;
  final FormzSubmissionStatus forgotPasswordResendOTPStatus;
  final FormzSubmissionStatus forgotPasswordOTPStatus;
  final int forgotPasswordOTPTimeLeft;
  final bool isForgotPasswordOTPTimeFinished;
  final InvalidValidationInput forgotPasswordOTP;
  final bool isForgotPasswordOTPValid;
  final String otpErrorMessage;
  final FormzSubmissionStatus forgotPasswordPasswordStatus;
  final InvalidValidationInput forgotPasswordPassword;
  final MismatchValidationInput forgotPasswordConfirmPassword;
  final bool isForgotPasswordPasswordValid;
  final bool isForgotPasswordPasswordObscure;
  final bool isForgotPasswordConfirmPasswordObscure;

  AuthState copyWith({
    GeneralApiState<void>? loginStatus,
    InvalidValidationInput? loginEmail,
    EmptyValidationInput? loginPassword,
    bool? isLoginPasswordObscure,
    bool? isLoginValid,
    String? loginErrorMessage,
    GeneralApiState<void>? registerStatus,
    EmptyValidationInput? registerPhoto,
    InvalidValidationInput? registerName,
    InvalidValidationInput? registerEmail,
    InvalidValidationInput? registerUsername,
    EmptyValidationInput? registerDOB,
    InvalidValidationInput? registerPassword,
    MismatchValidationInput? registerConfirmPassword,
    bool? isRegisterPasswordObscure,
    bool? isRegisterConfirmPasswordObscure,
    bool? isRegisterValid,
    AuthExceptionModel? registerException,
    bool? isCurrentPageLogin,
    FormzSubmissionStatus? forgotPasswordEmailStatus,
    InvalidValidationInput? forgotPasswordEmail,
    bool? isForgotPasswordEmailValid,
    AuthExceptionModel? forgotPasswordException,
    FormzSubmissionStatus? forgotPasswordResendOTPStatus,
    FormzSubmissionStatus? forgotPasswordOTPStatus,
    int? forgotPasswordOTPTimeLeft,
    bool? isForgotPasswordOTPTimeFinished,
    InvalidValidationInput? forgotPasswordOTP,
    bool? isForgotPasswordOTPValid,
    String? otpErrorMessage,
    FormzSubmissionStatus? forgotPasswordPasswordStatus,
    InvalidValidationInput? forgotPasswordPassword,
    MismatchValidationInput? forgotPasswordConfirmPassword,
    bool? isForgotPasswordPasswordObscure,
    bool? isForgotPasswordConfirmPasswordObscure,
    bool? isForgotPasswordPasswordValid,
  }) =>
      AuthState(
        loginStatus: loginStatus ?? this.loginStatus,
        loginEmail: loginEmail ?? this.loginEmail,
        loginPassword: loginPassword ?? this.loginPassword,
        isLoginPasswordObscure:
            isLoginPasswordObscure ?? this.isLoginPasswordObscure,
        isLoginValid: isLoginValid ?? this.isLoginValid,
        registerStatus: registerStatus ?? this.registerStatus,
        registerPhoto: registerPhoto ?? this.registerPhoto,
        registerName: registerName ?? this.registerName,
        registerEmail: registerEmail ?? this.registerEmail,
        registerUsername: registerUsername ?? this.registerUsername,
        registerDOB: registerDOB ?? this.registerDOB,
        registerPassword: registerPassword ?? this.registerPassword,
        registerConfirmPassword:
            registerConfirmPassword ?? this.registerConfirmPassword,
        isRegisterPasswordObscure:
            isRegisterPasswordObscure ?? this.isRegisterPasswordObscure,
        isRegisterConfirmPasswordObscure: isRegisterConfirmPasswordObscure ??
            this.isRegisterConfirmPasswordObscure,
        isRegisterValid: isRegisterValid ?? this.isRegisterValid,
        registerException: registerException ?? this.registerException,
        isCurrentPageLogin: isCurrentPageLogin ?? this.isCurrentPageLogin,
        forgotPasswordEmailStatus:
            forgotPasswordEmailStatus ?? this.forgotPasswordEmailStatus,
        forgotPasswordEmail: forgotPasswordEmail ?? this.forgotPasswordEmail,
        isForgotPasswordEmailValid:
            isForgotPasswordEmailValid ?? this.isForgotPasswordEmailValid,
        forgotPasswordException:
            forgotPasswordException ?? this.forgotPasswordException,
        forgotPasswordResendOTPStatus:
            forgotPasswordResendOTPStatus ?? this.forgotPasswordResendOTPStatus,
        forgotPasswordOTPStatus:
            forgotPasswordOTPStatus ?? this.forgotPasswordOTPStatus,
        forgotPasswordOTPTimeLeft:
            forgotPasswordOTPTimeLeft ?? this.forgotPasswordOTPTimeLeft,
        isForgotPasswordOTPTimeFinished: isForgotPasswordOTPTimeFinished ??
            this.isForgotPasswordOTPTimeFinished,
        forgotPasswordOTP: forgotPasswordOTP ?? this.forgotPasswordOTP,
        isForgotPasswordOTPValid:
            isForgotPasswordOTPValid ?? this.isForgotPasswordOTPValid,
        otpErrorMessage: otpErrorMessage ?? this.otpErrorMessage,
        forgotPasswordPasswordStatus:
            forgotPasswordPasswordStatus ?? this.forgotPasswordPasswordStatus,
        forgotPasswordPassword:
            forgotPasswordPassword ?? this.forgotPasswordPassword,
        forgotPasswordConfirmPassword:
            forgotPasswordConfirmPassword ?? this.forgotPasswordConfirmPassword,
        isForgotPasswordPasswordObscure: isForgotPasswordPasswordObscure ??
            this.isForgotPasswordPasswordObscure,
        isForgotPasswordConfirmPasswordObscure:
            isForgotPasswordConfirmPasswordObscure ??
                this.isForgotPasswordConfirmPasswordObscure,
        isForgotPasswordPasswordValid:
            isForgotPasswordPasswordValid ?? this.isForgotPasswordPasswordValid,
      );

  @override
  List<Object> get props => [
        loginStatus,
        loginEmail,
        loginPassword,
        isLoginPasswordObscure,
        isLoginValid,
        registerStatus,
        registerPhoto,
        registerName,
        registerEmail,
        registerUsername,
        registerDOB,
        registerPassword,
        registerConfirmPassword,
        isRegisterPasswordObscure,
        isRegisterConfirmPasswordObscure,
        isRegisterValid,
        registerException,
        isCurrentPageLogin,
        forgotPasswordEmailStatus,
        forgotPasswordEmail,
        isForgotPasswordEmailValid,
        forgotPasswordException,
        forgotPasswordResendOTPStatus,
        forgotPasswordOTPStatus,
        forgotPasswordOTPTimeLeft,
        isForgotPasswordOTPTimeFinished,
        forgotPasswordOTP,
        isForgotPasswordOTPValid,
        otpErrorMessage,
        forgotPasswordPasswordStatus,
        forgotPasswordPassword,
        forgotPasswordConfirmPassword,
        isForgotPasswordPasswordObscure,
        isForgotPasswordConfirmPasswordObscure,
        isForgotPasswordPasswordValid,
      ];
}
