part of 'cart_cubit.dart';





class CartState extends Equatable {
  const CartState({

    this.cancelBookingApiState = const GeneralApiState<void>(),


  });


  final GeneralApiState<void> cancelBookingApiState;


  CartState copyWith({

    GeneralApiState<void>? cancelBookingApiState,

  }) => CartState(
  
    cancelBookingApiState: cancelBookingApiState ?? this.cancelBookingApiState,

  );

  @override
  List<Object> get props => [
   
    cancelBookingApiState,

  ];
}
