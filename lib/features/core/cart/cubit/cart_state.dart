part of 'cart_cubit.dart';

class CartState extends Equatable {
  const CartState({this.getCartListingApiState = const GeneralApiState<List<CartListingModel>>(),this.postCartApiState = const GeneralApiState<void>()});

  final GeneralApiState<List<CartListingModel>> getCartListingApiState;
  final GeneralApiState<void> postCartApiState;

  CartState copyWith({GeneralApiState<List<CartListingModel>>? getCartListingApiState, GeneralApiState<void>? postCartApiState}) =>
      CartState(
        getCartListingApiState: getCartListingApiState ?? this.getCartListingApiState,
        postCartApiState: postCartApiState ?? this.postCartApiState,
      );

  @override
  List<Object> get props => [getCartListingApiState, postCartApiState];
}
