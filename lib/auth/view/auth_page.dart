part of 'view.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(context.read<AuthenticationRepository>()),
      child: const AuthView(),
    );
  }
}

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isCurrentPageLogin =
        context.select((AuthCubit cubit) => cubit.state.isCurrentPageLogin);

    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.loginStatus != current.loginStatus ||
          previous.registerStatus != current.registerStatus,
      listener: (context, state) {
        if (state.loginStatus.apiCallState == APICallState.loaded) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text(translate(context, 'logged_in'),
                  style: AppTextTheme().bodyText),
              content: Text(
                translate(context, 'sync_drive_description'),
                style: context.lightText.copyWith(fontSize: 18),
              ),
              actions: [
                TextButton(
                  onPressed: () => context
                    .popUntilPage(),
                  child: Text(translate(context, 'ok'),
                      style: AppTextTheme().bodyText),
                ),
              ],
            ),
          );
        }
        if (state.loginStatus.apiCallState == APICallState.failure) {
          context.showSnackbar(
            state.loginStatus.errorMessage ??
                translate(context, 'something_went_wrong'),
            backgroundColor: AppColorTheme().red,
          );
        }
        if (state.registerStatus.apiCallState == APICallState.loaded) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text(translate(context, 'registered'),
                  style: AppTextTheme().bodyText),
              content: Text(
                translate(context, 'sync_drive_description'),
                style: context.lightText.copyWith(fontSize: 18),
              ),
              actions: [
                TextButton(
                  onPressed: () => context
                    ..popPage()
                    ..popPage(),
                  child: Text(translate(context, 'ok'),
                      style: AppTextTheme().bodyText),
                ),
              ],
            ),
          );
        }
        if (state.registerStatus.apiCallState == APICallState.failure) {
          context.showSnackbar(
            (state.registerException.message != null &&
                    state.registerException.message!.isNotEmpty)
                ? state.registerException.message!
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
              isCurrentPageLogin ? const _LoginView() : const _RegisterView(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          translate(context, 'sign_in_account'),
          textAlign: TextAlign.center,
          style: context.headingText
              .copyWith(fontSize: 32, fontWeight: AppFontWeight.extraBold),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(translate(context, 'don\'t_have_an_account'),
                textAlign: TextAlign.center,
                style: context.bodyText.copyWith(fontSize: 14)),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () => context.read<AuthCubit>().currentPageChanged(),
              child: Text(translate(context, 'sign_up'),
                  textAlign: TextAlign.center,
                  style: context.bodyText.copyWith(
                      fontSize: 14,
                      fontWeight: AppFontWeight.bold,
                      color: AppColorTheme().primary)),
            ),
          ],
        ),
        const SizedBox(height: 24),
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
              _LoginEmailInput(),
              Divider(),
              _LoginPasswordInput(),
            ],
          ),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () => context.pushPage(
              ForgotPasswordEmailPage(cubit: context.read<AuthCubit>())),
          child: Text(translate(context, 'forgot_your_pass'),
              style: context.bodyText.copyWith(
                color: AppColorTheme().primary,
                decoration: TextDecoration.underline,
                decorationColor: AppColorTheme().primary,
                decorationThickness: 3,
                fontSize: 12,
                fontWeight: AppFontWeight.bold,
              )),
        ),
        const SizedBox(height: 24),
        const _LoginSubmit(),
        const SizedBox(height: 24),
        const _LoginSocial()
      ],
    );
  }
}

class _LoginEmailInput extends StatelessWidget {
  const _LoginEmailInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.loginEmail != current.loginEmail,
      builder: (context, state) {
        return AuthTextField(
          initialValue: state.loginEmail.isPure ? null : state.loginEmail.value,
          onChanged: (value) =>
              context.read<AuthCubit>().loginEmailChanged(value),
          hintText: translate(context, 'email'),
          keyboardType: TextInputType.emailAddress,
          icon: AppIcons().email,
          error: state.loginEmail.displayError != null
              ? CustomTextfieldErrorWidget(
                  title: _buildErrorText(state, context))
              : null,
        );
      },
    );
  }

  String? _buildErrorText(AuthState state, BuildContext context) {
    final error = state.loginEmail.error;

    if (error == InvalidValidationError.empty) {
      return translate(context, 'email_address_required');
    } else if (error == InvalidValidationError.invalid) {
      return translate(context, 'email_address_invalid');
    }

    return null;
  }
}

class _LoginPasswordInput extends StatelessWidget {
  const _LoginPasswordInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.loginPassword != current.loginPassword ||
          previous.isLoginPasswordObscure != current.isLoginPasswordObscure,
      builder: (context, state) {
        return AuthTextField(
          initialValue:
              state.loginPassword.isPure ? null : state.loginPassword.value,
          onChanged: (value) =>
              context.read<AuthCubit>().loginPasswordChanged(value),
          obscureText: state.isLoginPasswordObscure,
          hintText: translate(context, 'password'),
          icon: AppIcons().lock2,
          suffixIcon: GestureDetector(
            onTap: () =>
                context.read<AuthCubit>().loginPasswordObscureChanged(),
            child: Icon(
              state.isLoginPasswordObscure
                  ? AppIcons().visibleOff
                  : AppIcons().visible,
              color: AppColorTheme().primary,
            ),
          ),
          error: state.loginPassword.displayError != null
              ? CustomTextfieldErrorWidget(
                  title: translate(context, 'password_required'))
              : null,
        );
      },
    );
  }
}

class _LoginSubmit extends StatelessWidget {
  const _LoginSubmit();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.loginStatus != current.loginStatus,
      builder: (context, state) {
        return state.loginStatus.apiCallState == APICallState.loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : CustomElevatedButton(
                onTap: () => context.read<AuthCubit>().login(),
                width: double.infinity,
                title: translate(context, 'login'),
                fontSize: 16,
              );
      },
    );
  }
}

class _LoginSocial extends StatelessWidget {
  const _LoginSocial();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.loginStatus != current.loginStatus,
      builder: (context, state) {
        return state.loginStatus.apiCallState == APICallState.loading
            ? const SizedBox()
            : Column(
                children: [
                  Row(
                    children: [
                      const Flexible(child: Divider()),
                      const SizedBox(width: 15),
                      Text(translate(context, 'or_login_with'),
                          style: context.bodyText.copyWith(
                            fontSize: 12,
                            color:
                                context.monochromeColor.withValues(alpha: 0.5),
                          )),
                      const SizedBox(width: 15),
                      const Flexible(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Platform.isIOS
                      ? AuthCard(
                          onTap: () =>
                              context.read<AuthCubit>().signInWithApple(),
                          imageUrl: AppImages.apple,
                        )
                      : AuthCard(
                          onTap: () =>
                              context.read<AuthCubit>().signInWithGoogle(),
                          imageUrl: AppImages.google,
                        ),
                  const SizedBox(height: 24),
                ],
              );
      },
    );
  }
}

class _RegisterView extends StatelessWidget {
  const _RegisterView();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(translate(context, 'create_account'),
            textAlign: TextAlign.center,
            style: context.headingText.copyWith(
                fontSize: 32, fontWeight: AppFontWeight.extraBold)),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${translate(context, 'already_have_account')}?',
                textAlign: TextAlign.center,
                style: context.bodyText.copyWith(fontSize: 14)),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () => context.read<AuthCubit>().currentPageChanged(),
              child: Text(translate(context, 'login'),
                  textAlign: TextAlign.center,
                  style: context.bodyText.copyWith(
                      fontSize: 14,
                      fontWeight: AppFontWeight.bold,
                      color: AppColorTheme().primary)),
            ),
          ],
        ),
        const SizedBox(height: 24),
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
              _RegisterPhotoInput(),
              Divider(),
              _RegisterNameInput(),
              Divider(),
              _RegisterEmailInput(),
              Divider(),
              _RegisterUsernameInput(),
              Divider(),
              _RegisterDOBInput(),
              Divider(),
              _RegisterPasswordInput(),
              Divider(),
              _RegisterConfirmPasswordInput(),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const _RegisterSubmit(),
      ],
    );
  }
}

class _RegisterPhotoInput extends StatelessWidget {
  const _RegisterPhotoInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.registerPhoto != current.registerPhoto ||
          previous.registerException != current.registerException,
      builder: (context, state) {
        return AuthTextField(
          onTap: () => context.read<AuthCubit>().registerPhotoChanged(),
          readOnly: true,
          hintText: state.registerPhoto.value.isEmpty
              ? translate(context, 'upload_your_photo')
              : translate(context, 'change_your_photo'),
          icon: AppIcons().photo,
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: AppColorTheme().lightGrey,
              child: state.registerPhoto.value.isEmpty
                  ? Icon(
                      AppIcons().upload,
                      size: 30,
                      color: AppColorTheme().black.withValues(alpha: 0.5),
                    )
                  : ClipOval(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(
                              File(state.registerPhoto.value),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          error: (state.registerException.errors?.profilePic != null &&
                  state.registerException.errors!.profilePic!.isNotEmpty)
              ? CustomTextfieldErrorWidget(
                  title: state.registerException.errors!.profilePic!.first)
              : state.registerPhoto.displayError != null
                  ? CustomTextfieldErrorWidget(
                      title: translate(context, 'photo_required'),
                    )
                  : null,
        );
      },
    );
  }
}

class _RegisterNameInput extends StatelessWidget {
  const _RegisterNameInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.registerName != current.registerName ||
          previous.registerException != current.registerException,
      builder: (context, state) {
        return AuthTextField(
          initialValue:
              state.registerName.isPure ? null : state.registerName.value,
          onChanged: (value) =>
              context.read<AuthCubit>().registerNameChanged(value),
          hintText: translate(context, 'name'),
          icon: AppIcons().profile,
          error: (state.registerException.errors?.name != null &&
                  state.registerException.errors!.name!.isNotEmpty)
              ? CustomTextfieldErrorWidget(
                  title: state.registerException.errors!.name!.first)
              : state.registerName.displayError != null
                  ? CustomTextfieldErrorWidget(
                      title: _buildErrorText(state, context))
                  : null,
        );
      },
    );
  }

  String? _buildErrorText(AuthState state, BuildContext context) {
    final error = state.registerName.error;

    if (error == InvalidValidationError.empty) {
      return translate(context, 'name_required');
    } else if (error == InvalidValidationError.invalid) {
      return translate(context, 'name_validation');
    }

    return null;
  }
}

class _RegisterEmailInput extends StatelessWidget {
  const _RegisterEmailInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.registerEmail != current.registerEmail ||
          previous.registerException != current.registerException,
      builder: (context, state) {
        return AuthTextField(
          initialValue:
              state.registerEmail.isPure ? null : state.registerEmail.value,
          onChanged: (value) =>
              context.read<AuthCubit>().registerEmailChanged(value),
          hintText: translate(context, 'email'),
          keyboardType: TextInputType.emailAddress,
          icon: AppIcons().email,
          error: (state.registerException.errors?.email != null &&
                  state.registerException.errors!.email!.isNotEmpty)
              ? CustomTextfieldErrorWidget(
                  title: state.registerException.errors!.email!.first)
              : state.registerEmail.displayError != null
                  ? CustomTextfieldErrorWidget(
                      title: _buildErrorText(state, context))
                  : null,
        );
      },
    );
  }

  String? _buildErrorText(AuthState state, BuildContext context) {
    final error = state.registerEmail.error;

    if (error == InvalidValidationError.empty) {
      return translate(context, 'email_address_required');
    } else if (error == InvalidValidationError.invalid) {
      return translate(context, 'email_address_invalid');
    }

    return null;
  }
}

class _RegisterUsernameInput extends StatelessWidget {
  const _RegisterUsernameInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.registerUsername != current.registerUsername ||
          previous.registerException != current.registerException,
      builder: (context, state) {
        return AuthTextField(
          initialValue: state.registerUsername.isPure
              ? null
              : state.registerUsername.value,
          onChanged: (value) =>
              context.read<AuthCubit>().registerUsernameChanged(value),
          hintText: translate(context, 'username'),
          icon: AppIcons().profile,
          error: (state.registerException.errors?.username != null &&
                  state.registerException.errors!.username!.isNotEmpty)
              ? CustomTextfieldErrorWidget(
                  title: state.registerException.errors!.username!.first)
              : state.registerUsername.displayError != null
                  ? CustomTextfieldErrorWidget(
                      title: _buildErrorText(state, context))
                  : null,
        );
      },
    );
  }

  String? _buildErrorText(AuthState state, BuildContext context) {
    final error = state.registerUsername.error;

    if (error == InvalidValidationError.empty) {
      return translate(context, 'username_required');
    } else if (error == InvalidValidationError.invalid) {
      return translate(context, 'username_validation');
    }

    return null;
  }
}

class _RegisterDOBInput extends StatelessWidget {
  const _RegisterDOBInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.registerDOB != current.registerDOB ||
          previous.registerException != current.registerException,
      builder: (context, state) {
        return AuthTextField(
          controller: TextEditingController(text: state.registerDOB.value),
          onTap: () async {
            final authCubit = context.read<AuthCubit>();
            final DateTime now = DateTime.now();
            final DateTime eighteenYearsAgo =
                DateTime(now.year - 18, now.month, now.day);

            DateTime? pickedDate = await showDatePicker(
              context: context,
              firstDate: DateTime(1950),
              lastDate: eighteenYearsAgo,
              initialDate: eighteenYearsAgo,
              initialEntryMode: DatePickerEntryMode.calendarOnly,
            );

            if (pickedDate != null) {
              String formattedDate =
                  "${pickedDate.year}/${pickedDate.month}/${pickedDate.day}";

              authCubit.registerDOBChanged(formattedDate);
            }
          },
          hintText: translate(context, 'date_of_birth'),
          readOnly: true,
          icon: AppIcons().calendar,
          suffixIcon: Icon(
            AppIcons().calendar,
            color: AppColorTheme().black.withValues(alpha: 0.5),
          ),
          error: (state.registerException.errors?.dateOfBirth != null &&
                  state.registerException.errors!.dateOfBirth!.isNotEmpty)
              ? CustomTextfieldErrorWidget(
                  title: state.registerException.errors!.dateOfBirth!.first)
              : state.registerDOB.displayError != null
                  ? CustomTextfieldErrorWidget(
                      title: translate(context, 'date_of_birth_required'),
                    )
                  : null,
        );
      },
    );
  }
}

class _RegisterPasswordInput extends StatelessWidget {
  const _RegisterPasswordInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.registerPassword != current.registerPassword ||
          previous.isRegisterPasswordObscure !=
              current.isRegisterPasswordObscure,
      builder: (context, state) {
        return AuthTextField(
          initialValue: state.registerPassword.isPure
              ? null
              : state.registerPassword.value,
          onChanged: (value) =>
              context.read<AuthCubit>().registerPasswordChanged(value),
          obscureText: state.isRegisterPasswordObscure,
          hintText: translate(context, 'password'),
          icon: AppIcons().lock2,
          suffixIcon: GestureDetector(
            onTap: () =>
                context.read<AuthCubit>().registerPasswordObscureChanged(),
            child: Icon(
              state.isRegisterPasswordObscure
                  ? AppIcons().visibleOff
                  : AppIcons().visible,
              color: AppColorTheme().primary,
            ),
          ),
          error: state.registerPassword.displayError != null
              ? CustomTextfieldErrorWidget(
                  title: _buildErrorText(state, context))
              : null,
        );
      },
    );
  }

  String? _buildErrorText(AuthState state, BuildContext context) {
    final error = state.registerPassword.error;

    if (error == InvalidValidationError.empty) {
      return translate(context, 'password_required');
    } else if (error == InvalidValidationError.invalid) {
      return translate(context, 'password_validation');
    }

    return null;
  }
}

class _RegisterConfirmPasswordInput extends StatelessWidget {
  const _RegisterConfirmPasswordInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.registerConfirmPassword != current.registerConfirmPassword ||
          previous.isRegisterConfirmPasswordObscure !=
              current.isRegisterConfirmPasswordObscure,
      builder: (context, state) {
        return AuthTextField(
          initialValue: state.registerConfirmPassword.isPure
              ? null
              : state.registerConfirmPassword.value,
          onChanged: (value) =>
              context.read<AuthCubit>().registerConfirmPasswordChanged(value),
          obscureText: state.isRegisterConfirmPasswordObscure,
          hintText: translate(context, 'confirm_password'),
          icon: AppIcons().lock2,
          suffixIcon: GestureDetector(
            onTap: () => context
                .read<AuthCubit>()
                .registerConfrimPasswordObscureChanged(),
            child: Icon(
              state.isRegisterConfirmPasswordObscure
                  ? AppIcons().visibleOff
                  : AppIcons().visible,
              color: AppColorTheme().primary,
            ),
          ),
          error: state.registerConfirmPassword.displayError != null &&
                  !state.registerPassword.isPure
              ? CustomTextfieldErrorWidget(
                  title: _buildErrorText(state, context))
              : null,
        );
      },
    );
  }

  String? _buildErrorText(AuthState state, BuildContext context) {
    final error = state.registerConfirmPassword.error;

    if (error == MismatchValidationError.empty) {
      return translate(context, 'confirm_password_required');
    } else if (error == MismatchValidationError.mismatch) {
      return translate(context, 'confirm_password_mismatch');
    }

    return null;
  }
}

class _RegisterSubmit extends StatelessWidget {
  const _RegisterSubmit();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.registerStatus != current.registerStatus ||
          previous.registerPhoto != current.registerPhoto,
      builder: (context, state) {
        return state.registerStatus.apiCallState == APICallState.loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : CustomElevatedButton(
                onTap: () {
                  const maxImageSize = 10 * 1024 * 1024;

                  bool hasLargeImage = state.registerPhoto.value.isNotEmpty &&
                      File(state.registerPhoto.value).lengthSync() >
                          maxImageSize;

                  if (hasLargeImage) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(translate(context, 'error'),
                            style: AppTextTheme().bodyText),
                        content:
                            Text(translate(context, 'profile_pic_size_exceed')),
                        actions: [
                          TextButton(
                            onPressed: () => context.popPage(),
                            child: Text(translate(context, 'ok'),
                                style: AppTextTheme().bodyText),
                          ),
                        ],
                      ),
                    );
                  } else {
                    context.read<AuthCubit>().register();
                  }
                },
                width: double.infinity,
                title: translate(context, 'register'),
                fontSize: 16,
              );
      },
    );
  }
}
