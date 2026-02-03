part of 'generics.dart';

void unauthorizedSnackbar(BuildContext context) => context.showSnackbar(
      'Access denied, Please upgrade your subscription.',
      backgroundColor: AppColorTheme().orange,
    );
