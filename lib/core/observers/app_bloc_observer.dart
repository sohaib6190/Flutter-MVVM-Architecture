import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log("📢 Event: ${bloc.runtimeType} -> $event");
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log(
      "🔄 State Change: ${bloc.runtimeType} -> ${change.currentState} ➡️ ${change.nextState}",
    );
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    // log("🔀 Transition: ${bloc.runtimeType} -> ${transition.event} | ${transition.currentState} ➡️ ${transition.nextState}",);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    log("❌ Error in ${bloc.runtimeType}: $error\n$stackTrace");
  }
}
