
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/features/core/cart/repository/repository.dart';

import '../../../../core/utils/generics/generics.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this.cartRepository) : super(const CartState());
  final CartRepository cartRepository;


  Future<void> cancelBooking(int bookingId) async {
    emit(
      state.copyWith(
        cancelBookingApiState: const GeneralApiState<void>(
          apiCallState: APICallState.loading,
        ),
      ),
    );

    await cartRepository
        .cancelBooking(bookingId)
        .then((value) {
          emit(
            state.copyWith(
              cancelBookingApiState: state.cancelBookingApiState.copyWith(
                apiCallState: APICallState.loaded,
              ),
            ),
          );
        })
        .catchError((e) {
          if (e is Map<String, dynamic>) {
            emit(
              state.copyWith(
                cancelBookingApiState: const GeneralApiState<void>(
                  apiCallState: APICallState.failure,
                ),
              ),
            );
          } else {
            emit(
              state.copyWith(
                cancelBookingApiState: GeneralApiState<void>(
                  apiCallState: APICallState.failure,
                  errorMessage: e.toString(),
                ),
              ),
            );
          }
        });
  }

}

