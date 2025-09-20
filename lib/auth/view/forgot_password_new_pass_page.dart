part of 'view.dart';

class ForgotPasswordNewPassPage extends StatelessWidget {
  const ForgotPasswordNewPassPage({super.key, required this.cubit});

  final AuthCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: const _ForgotPasswordNewPassView(),
    );
  }
}

class _ForgotPasswordNewPassView extends StatelessWidget {
  const _ForgotPasswordNewPassView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.forgotPasswordPasswordStatus !=
          current.forgotPasswordPasswordStatus,
      listener: (context, state) {
        if (state.forgotPasswordPasswordStatus ==
            FormzSubmissionStatus.success) {
          context.showSnackbar(
            translate(context, 'password_changed'),
            backgroundColor: AppColorTheme().green,
          );
          context
            ..popPage()
            ..popPage()
            ..popPage();
        }
        if (state.forgotPasswordPasswordStatus ==
            FormzSubmissionStatus.failure) {
          context.showSnackbar(
            translate(context, 'something_went_wrong'),
            backgroundColor: AppColorTheme().red,
          );
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, _) {
          if (didPop) return;
          context
            ..popPage()
            ..popPage();
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 15, top: 15),
              child: BackButtonWidget(
                onTap: () => context
                  ..popPage()
                  ..popPage(),
              ),
            ),
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
                  translate(context, 'enter_new_password'),
                  textAlign: TextAlign.center,
                  style: context.headingText.copyWith(
                      fontSize: 32, fontWeight: AppFontWeight.extraBold),
                ),
                const SizedBox(height: 12),
                Text(
                  translate(context, 'please_enter_new_password'),
                  textAlign: TextAlign.center,
                  style: context.lightText,
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColorTheme().white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColorTheme().black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Column(
                    children: [
                      _ForgotPasswordPassInput(),
                      Divider(),
                      _ForgotPassworConfirmPassInput(),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const _ForgotPasswordNewPassSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ForgotPasswordPassInput extends StatelessWidget {
  const _ForgotPasswordPassInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.forgotPasswordPassword != current.forgotPasswordPassword ||
          previous.isForgotPasswordPasswordObscure !=
              current.isForgotPasswordPasswordObscure,
      builder: (context, state) {
        return AuthTextField(
          onChanged: (value) =>
              context.read<AuthCubit>().forgotPasswordPasswordChanged(value),
          obscureText: state.isForgotPasswordPasswordObscure,
          hintText: translate(context, 'new_password'),
          icon: AppIcons().lock2,
          suffixIcon: GestureDetector(
            onTap: () => context
                .read<AuthCubit>()
                .forgotPasswordPasswordObscureChanged(),
            child: Icon(
              state.isForgotPasswordPasswordObscure
                  ? AppIcons().visibleOff
                  : AppIcons().visible,
              color: AppColorTheme().primary,
            ),
          ),
          error: state.forgotPasswordPassword.displayError != null
              ? CustomTextfieldErrorWidget(
                  title: _buildErrorText(state, context))
              : null,
        );
      },
    );
  }

  String? _buildErrorText(AuthState state, BuildContext context) {
    final error = state.forgotPasswordPassword.error;

    if (error == InvalidValidationError.empty) {
      return translate(context, 'new_password_required');
    } else if (error == InvalidValidationError.invalid) {
      return translate(context, 'password_validation');
    }

    return null;
  }
}

class _ForgotPassworConfirmPassInput extends StatelessWidget {
  const _ForgotPassworConfirmPassInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.forgotPasswordConfirmPassword !=
              current.forgotPasswordConfirmPassword ||
          previous.isForgotPasswordConfirmPasswordObscure !=
              current.isForgotPasswordConfirmPasswordObscure,
      builder: (context, state) {
        return AuthTextField(
          onChanged: (value) => context
              .read<AuthCubit>()
              .forgotPasswordConfirmPasswordChanged(value),
          obscureText: state.isForgotPasswordConfirmPasswordObscure,
          hintText: translate(context, 'confirm_password'),
          icon: AppIcons().lock2,
          suffixIcon: GestureDetector(
            onTap: () => context
                .read<AuthCubit>()
                .forgotPasswordConfirmPasswordObscureChanged(),
            child: Icon(
              state.isForgotPasswordConfirmPasswordObscure
                  ? AppIcons().visibleOff
                  : AppIcons().visible,
              color: AppColorTheme().primary,
            ),
          ),
          error: state.forgotPasswordConfirmPassword.displayError != null &&
                  !state.forgotPasswordPassword.isPure
              ? CustomTextfieldErrorWidget(
                  title: _buildErrorText(state, context))
              : null,
        );
      },
    );
  }

  String? _buildErrorText(AuthState state, BuildContext context) {
    final error = state.forgotPasswordConfirmPassword.error;

    if (error == MismatchValidationError.empty) {
      return translate(context, 'confirm_password_required');
    } else if (error == MismatchValidationError.mismatch) {
      return translate(context, 'confirm_password_mismatch');
    }

    return null;
  }
}

class _ForgotPasswordNewPassSubmit extends StatelessWidget {
  const _ForgotPasswordNewPassSubmit();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.forgotPasswordPasswordStatus !=
          current.forgotPasswordPasswordStatus,
      builder: (context, state) {
        return state.forgotPasswordPasswordStatus.isInProgress
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : CustomElevatedButton(
                onTap: () => context.read<AuthCubit>().forgotPassword(),
                width: double.infinity,
                title: translate(context, 'continue'),
                fontSize: 16,
              );
      },
    );
  }
}
