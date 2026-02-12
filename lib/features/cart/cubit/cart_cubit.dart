import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/features/cart/data/model/request/cart_add_params.dart';
import 'package:flutter_clean_architecture/features/cart/data/model/response/response.dart';
import 'package:flutter_clean_architecture/features/cart/data/repository/repository.dart';

import '../../../core/utils/generics/generics.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this.cartRepository) : super(const CartState());
  final CartRepository cartRepository;

  Future<void> getPostListing() async {
    emit(
      state.copyWith(
        getCartListingApiState: const GeneralApiState<List<CartListingModel>>(
          apiCallState: APICallState.loading,
        ),
      ),
    );
    await cartRepository
        .getPostListing()
        .then((value) {
          emit(
            state.copyWith(
              getCartListingApiState: GeneralApiState<List<CartListingModel>>(
                apiCallState: APICallState.loaded,
                model: value,
              ),
            ),
          );
        })
        .catchError((e) {
          if (e is String) {
            emit(
              state.copyWith(
                getCartListingApiState: GeneralApiState<List<CartListingModel>>(
                  apiCallState: APICallState.failure,
                  errorMessage: e.toString(),
                ),
              ),
            );
          } else {
            emit(
              state.copyWith(
                getCartListingApiState: GeneralApiState<List<CartListingModel>>(
                  apiCallState: APICallState.failure,
                  errorMessage: e.toString(),
                ),
              ),
            );
          }
        });
  }

  
  Future<void> postAddCart(CartAddParams params) async {
    emit(
      state.copyWith(
        postCartApiState: const GeneralApiState<void>(
          apiCallState: APICallState.loading,
        ),
      ),
    );
    await cartRepository
        .addCart(params)
        .then((value) {
          emit(
            state.copyWith(
              postCartApiState: GeneralApiState<void>(
                apiCallState: APICallState.loaded,
         
              ),
            ),
          );
        })
        .catchError((e) {
          if (e is String) {
            emit(
              state.copyWith(
                postCartApiState: GeneralApiState<void>(
                  apiCallState: APICallState.failure,
                  errorMessage: e.toString(),
                ),
              ),
            );
          } else {
            emit(
              state.copyWith(
                postCartApiState: GeneralApiState<void>(
                  apiCallState: APICallState.failure,
                  errorMessage: e.toString(),
                ),
              ),
            );
          }
        });
  }
}
