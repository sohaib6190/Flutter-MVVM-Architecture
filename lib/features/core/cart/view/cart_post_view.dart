part of 'view.dart';

class CartPostView extends StatelessWidget {
  const CartPostView({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (context) => sl.get<CartCubit>(),
      child: CartPostPage()
    );
  }
}

class CartPostPage extends StatelessWidget {
  const CartPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart Post")),
      body: Padding(
        padding: context.pagePadding(),
        child: Column(children: [Center(child: _addCartButton(context))]),
      ),
    );
  }
}

Widget _addCartButton(BuildContext context) {
  return BlocBuilder<CartCubit, CartState>(
    buildWhen: (previous, current) => previous.postCartApiState != current.postCartApiState,
    builder: (context, state) {
      return CustomElevatedButton(
        width: double.infinity,
        isLoading: state.postCartApiState.apiCallState == APICallState.loading,
        title: "Add to Cart",
        onTap: () {
          final params = CartAddParams(
            userId: 1,
            products: [ProductParams(id: 1), ProductParams(id: 2)],
          );

          context.read<CartCubit>().postAddCart(params);
        },
      );
    },
  );
}
