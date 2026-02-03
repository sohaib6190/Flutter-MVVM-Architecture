
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



part 'root_state.dart';

class RootCubit extends Cubit<RootState> {
  RootCubit() : super(const RootState());



  void getNavBarItem(NavBarItem navBarItem) {
    switch (navBarItem) {
      case NavBarItem.maps:
        emit(state.copyWith(navBarItem: NavBarItem.maps));
        break;
      case NavBarItem.jobs:
        emit(state.copyWith(navBarItem: NavBarItem.jobs));
        break;
      case NavBarItem.social:
        emit(state.copyWith(navBarItem: NavBarItem.social));
        break;
      case NavBarItem.ads:
        emit(state.copyWith(navBarItem: NavBarItem.ads));
        break;
      case NavBarItem.more:
        emit(state.copyWith(navBarItem: NavBarItem.more));
        break;
    }
  }

  }

