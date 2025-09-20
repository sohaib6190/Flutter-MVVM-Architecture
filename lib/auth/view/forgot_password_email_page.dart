part of 'view.dart';

class ForgotPasswordEmailPage extends StatelessWidget {
  const ForgotPasswordEmailPage({super.key, required this.cubit});

  final AuthCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(context.read<AuthenticationRepository>()),
      child: const _ForgotPasswordEmailView(),
    );
  }
}

class _ForgotPasswordEmailView extends StatelessWidget {
  const _ForgotPasswordEmailView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.forgotPasswordEmailStatus !=
          current.forgotPasswordEmailStatus,
      listener: (context, state) {
        if (state.forgotPasswordEmailStatus == FormzSubmissionStatus.success) {
          context.showSnackbar(
            translate(context, 'otp_sent'),
            backgroundColor: AppColorTheme().green,
          );
          context.pushPage(
              ForgotPasswordOtpPage(cubit: context.read<AuthCubit>()));
        }
        if (state.forgotPasswordEmailStatus == FormzSubmissionStatus.failure) {
          context.showSnackbar(
            (state.forgotPasswordException.message != null &&
                    state.forgotPasswordException.message!.isNotEmpty)
                ? state.forgotPasswordException.message!
                : translate(context, 'something_went_wrong'),
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
                translate(context, 'forgot_password'),
                textAlign: TextAlign.center,
                style: context.headingText.copyWith(
                    fontSize: 32, fontWeight: AppFontWeight.extraBold),
              ),
              const SizedBox(height: 12),
              Text(
                translate(context, 'enter_your_email'),
                textAlign: TextAlign.center,
                style: context.lightText,
              ),
              const SizedBox(height: 32),
              const _ForgotPasswordEmailInput(),
              const SizedBox(height: 24),
              const _ForgotPasswordEmailSubmit(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ForgotPasswordEmailInput extends StatelessWidget {
  const _ForgotPasswordEmailInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.forgotPasswordEmail != current.forgotPasswordEmail ||
          previous.forgotPasswordException != current.forgotPasswordException,
      builder: (context, state) {
        return Container(
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
          child: CustomTextField(
            onChanged: (value) =>
                context.read<AuthCubit>().forgotPasswordEmailChanged(value),
            fillColor: AppColorTheme().white,
            hintText: translate(context, 'email'),
            keyboardType: TextInputType.emailAddress,
            hintStyle: context.bodyText.copyWith(
                fontSize: 14,
                color: AppColorTheme().black.withValues(alpha: 0.5)),
            contentStyle: context.bodyText
                .copyWith(fontSize: 14, color: AppColorTheme().black),
            prefixIcon: Icon(
              AppIcons().email,
              color: AppColorTheme().primary,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            error: (state.forgotPasswordException.errors?.email != null &&
                    state.forgotPasswordException.errors!.email!.isNotEmpty)
                ? CustomTextfieldErrorWidget(
                    title: state.forgotPasswordException.errors!.email!.first,
                    padding: const EdgeInsets.only(bottom: 8),
                  )
                : state.forgotPasswordEmail.displayError != null
                    ? CustomTextfieldErrorWidget(
                        title: _buildErrorText(state, context),
                        padding: const EdgeInsets.only(bottom: 8),
                      )
                    : null,
          ),
        );
      },
    );
  }

  String? _buildErrorText(AuthState state, BuildContext context) {
    final error = state.forgotPasswordEmail.error;

    if (error == InvalidValidationError.empty) {
      return translate(context, 'email_address_required');
    } else if (error == InvalidValidationError.invalid) {
      return translate(context, 'email_address_invalid');
    }

    return null;
  }
}

class _ForgotPasswordEmailSubmit extends StatelessWidget {
  const _ForgotPasswordEmailSubmit();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.forgotPasswordEmailStatus !=
          current.forgotPasswordEmailStatus,
      builder: (context, state) {
        return state.forgotPasswordEmailStatus.isInProgress
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : CustomElevatedButton(
                onTap: () =>
                    context.read<AuthCubit>().forgotPasswordEmailSent(),
                width: double.infinity,
                title: translate(context, 'continue'),
                fontSize: 16,
              );
      },
    );
  }
}
