part of 'view.dart';

class ForgotPasswordOtpPage extends StatelessWidget {
  const ForgotPasswordOtpPage({super.key, required this.cubit});

  final AuthCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit..forgotPasswordStartTimer(),
      child: const _ForgotPasswordOtpView(),
    );
  }
}

class _ForgotPasswordOtpView extends StatelessWidget {
  const _ForgotPasswordOtpView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.forgotPasswordOTPStatus != current.forgotPasswordOTPStatus ||
          previous.forgotPasswordResendOTPStatus !=
              current.forgotPasswordResendOTPStatus,
      listener: (context, state) {
        if (state.forgotPasswordOTPStatus == FormzSubmissionStatus.success) {
          context.showSnackbar(
            translate(context, 'otp_verified'),
            backgroundColor: AppColorTheme().green,
          );
          context.pushPage(
              ForgotPasswordNewPassPage(cubit: context.read<AuthCubit>()));
        }
        if (state.forgotPasswordOTPStatus == FormzSubmissionStatus.failure) {
          context.showSnackbar(
            state.otpErrorMessage.isEmpty
                ? translate(context, 'something_went_wrong')
                : state.otpErrorMessage,
            backgroundColor: AppColorTheme().red,
          );
        }
        if (state.forgotPasswordResendOTPStatus ==
            FormzSubmissionStatus.success) {
          context.showSnackbar(
            translate(context, 'otp_sent'),
            backgroundColor: AppColorTheme().green,
          );
          context.read<AuthCubit>().forgotPasswordStartTimer();
        }
        if (state.forgotPasswordResendOTPStatus ==
            FormzSubmissionStatus.failure) {
          context.showSnackbar(
            translate(context, 'something_went_wrong'),
            backgroundColor: AppColorTheme().red,
          );
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: const Padding(
              padding: EdgeInsets.only(left: 15, top: 15),
              child: BackButtonWidget()),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(context.isDarkTheme
                  ? AppImages.authDarkBackground
                  : AppImages.authLightBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 120),
              context.isDarkTheme
                  ? Image.asset(AppImages.logo, width: 80, height: 80)
                  : Center(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColorTheme().black,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Image.asset(AppImages.logo,
                            width: 80, height: 80),
                      ),
                    ),
              const SizedBox(height: 24),
              Text(
                translate(context, 'enter_otp'),
                textAlign: TextAlign.center,
                style: context.headingText.copyWith(
                    fontSize: 32, fontWeight: AppFontWeight.extraBold),
              ),
              const SizedBox(height: 12),
              Text(
                translate(context, 'otp_sent'),
                textAlign: TextAlign.center,
                style: context.lightText,
              ),
              const SizedBox(height: 32),
              const _ForgotPasswordOTPInput(),
              const SizedBox(height: 12),
              const _ForgotPasswordOTPTimerAndResend(),
              const SizedBox(height: 24),
              const _ForgotPasswordOTPSubmit(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ForgotPasswordOTPInput extends StatelessWidget {
  const _ForgotPasswordOTPInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.forgotPasswordOTP != current.forgotPasswordOTP,
      builder: (context, state) {
        return PinCodeTextField(
          onChanged: (value) =>
              context.read<AuthCubit>().forgotPasswordOtpChanged(value),
          length: 4,
          enableActiveFill: true,
          separatorBuilder: (context, index) => Text(
            '-',
            style: context.bodyText.copyWith(
              color: context.monochromeColor,
            ),
          ),
          cursorColor: context.monochromeColor,
          obscureText: false,
          animationType: AnimationType.fade,
          keyboardType: TextInputType.number,
          textStyle: context.bodyText,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            FilteringTextInputFormatter.allow(
              RegExp(r'[1-9]\d*'),
            ),
          ],
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            fieldOuterPadding: EdgeInsets.zero,
            borderRadius: BorderRadius.circular(12),
            fieldHeight: 46,
            fieldWidth: 52,
            borderWidth: 1,
            selectedFillColor: Colors.transparent,
            activeFillColor: AppColorTheme().primary,
            activeColor: AppColorTheme().primary,
            selectedColor: AppColorTheme().primary,
            inactiveColor: AppColorTheme().lightGrey,
            inactiveFillColor: AppColorTheme().lightBackground,
          ),
          animationDuration: const Duration(milliseconds: 300),
          appContext: context,
        );
      },
    );
  }
}

class _ForgotPasswordOTPTimerAndResend extends StatelessWidget {
  const _ForgotPasswordOTPTimerAndResend();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.forgotPasswordResendOTPStatus !=
              current.forgotPasswordResendOTPStatus ||
          previous.forgotPasswordOTPStatus != current.forgotPasswordOTPStatus ||
          previous.forgotPasswordOTPTimeLeft !=
              current.forgotPasswordOTPTimeLeft ||
          previous.isForgotPasswordOTPTimeFinished !=
              current.isForgotPasswordOTPTimeFinished,
      builder: (context, state) {
        return !state.forgotPasswordResendOTPStatus.isInProgress ||
                !state.forgotPasswordOTPStatus.isInProgress
            ? Center(
                child: state.isForgotPasswordOTPTimeFinished
                    ? GestureDetector(
                        onTap: () =>
                            context.read<AuthCubit>().forgotPasswordResendOTP(),
                        child: Text(
                          translate(context, 'resend_otp'),
                          style: context.bodyText.copyWith(
                              decoration: TextDecoration.underline,
                              decorationColor: AppColorTheme().white),
                        ),
                      )
                    : RichText(
                        text: TextSpan(
                          style: context.bodyText,
                          children: [
                            TextSpan(
                              text: '${translate(context, 'resend_otp_in')} ',
                            ),
                            TextSpan(
                              text: _formattedTime(state),
                              style: context.bodyText.copyWith(
                                color: AppColorTheme().primary,
                              ),
                            ),
                          ],
                        ),
                      ),
              )
            : const SizedBox();
      },
    );
  }

  String _formattedTime(AuthState state) {
    final int minutes = state.forgotPasswordOTPTimeLeft ~/ 60;
    final int seconds = state.forgotPasswordOTPTimeLeft % 60;

    final String formattedTime =
        '$minutes:${seconds.toString().padLeft(2, '0')}';

    return formattedTime;
  }
}

class _ForgotPasswordOTPSubmit extends StatelessWidget {
  const _ForgotPasswordOTPSubmit();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.forgotPasswordOTPStatus != current.forgotPasswordOTPStatus ||
          previous.forgotPasswordResendOTPStatus !=
              current.forgotPasswordResendOTPStatus ||
          previous.isForgotPasswordOTPValid != current.isForgotPasswordOTPValid,
      builder: (context, state) {
        return state.forgotPasswordOTPStatus.isInProgress ||
                state.forgotPasswordResendOTPStatus.isInProgress
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Opacity(
                opacity: state.isForgotPasswordOTPValid ? 1 : 0.4,
                child: CustomElevatedButton(
                  onTap: state.isForgotPasswordOTPValid
                      ? () =>
                          context.read<AuthCubit>().forgotPasswordOtpVerified()
                      : null,
                  width: double.infinity,
                  title: translate(context, 'continue'),
                  fontSize: 16,
                ),
              );
      },
    );
  }
}
