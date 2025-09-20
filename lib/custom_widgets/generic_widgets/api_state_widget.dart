part of 'generic_widgets.dart';

class ApiStateWidget extends StatelessWidget {
  const ApiStateWidget({
    super.key,
    required this.successWidget,
    this.onRetry,
    this.generalApiState = const GeneralApiState(),
    this.onCancel,
    this.initialWidget,
    this.loadingWidget,
    this.failureWidget,
    this.textColor,
  });

  final GeneralApiState generalApiState;
  final Widget successWidget;
  final Function()? onRetry;
  final Function()? onCancel;
  final Widget? failureWidget;
  final Widget? loadingWidget;
  final Widget? initialWidget;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    switch (generalApiState.apiCallState) {
      case APICallState.initial:
        return _buildIntialWidget();
      case APICallState.loading:
        return _buildLoadingWidget();
      case APICallState.failure:
        return _buildFailureWidget();
      case APICallState.loaded:
        return successWidget;
    }
  }

  Widget _buildFailureWidget() =>
      failureWidget ??
      FailureStateWidget(
        key: const Key("failure_state_widget"),
        message: generalApiState.errorMessage ??
            "Something went wrong please try again!",
        onRetry: () {
          onRetry?.call();
        },
        onCancel: onCancel,
        textColor: textColor,
      );

  Widget _buildLoadingWidget() =>
      loadingWidget ??
      const LoadingStateWidget(
        key: Key("loading_state_widget"),
      );

  Widget _buildIntialWidget() => initialWidget ?? Container();
}

class FailureStateWidget extends StatelessWidget {
  const FailureStateWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.onCancel,
    this.textColor,
  });

  final String message;
  final Function() onRetry;
  final Function()? onCancel;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: AppTextTheme().bodyText,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            CustomElevatedButton(
              key: const Key("retry_button"),
              onTap: onRetry,
              title: "Retry",
              radius: 12,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            ),
            const SizedBox(height: 12),
            if (onCancel != null)
              TextButton(
                key: const Key("cancel_button"),
                onPressed: onCancel,
                child: Text("Cancel", style: AppTextTheme().bodyText),
              ),
          ],
        ),
      ),
    );
  }
}

class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
