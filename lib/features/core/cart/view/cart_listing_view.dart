part of 'view.dart';

class CartListingView extends StatelessWidget {
  const CartListingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl.get<CartCubit>(),
      child: CartListingPage(),
    );
  }
}

class CartListingPage extends StatefulWidget {
  const CartListingPage({super.key});

  @override
  State<CartListingPage> createState() => _CartListingPageState();
}

class _CartListingPageState extends State<CartListingPage> {
  @override
  void initState() {
    context.read<CartCubit>().getPostListing();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart Listing")),
      body: Padding(
        padding: context.pagePadding(),
        child: Column(children: [
          GestureDetector(
            onTap: () {
              context.pushNamed(AppRoutes.addCart,extra: CartAddParams(
                userId: 1,
                products: [ProductParams(id: 1), ProductParams(id: 2)],
              ));
            },
            child: Text("Post Cart")),
          
          Expanded(child: _cartListing())]),
      ),
    );
  }

  Widget _cartListing() {
    return BlocBuilder<CartCubit, CartState>(
      buildWhen: (previous, current) =>
          previous.getCartListingApiState != current.getCartListingApiState,
      builder: (context, state) {
        return ApiStateWidget(
          generalApiState: state.getCartListingApiState,
          loadingWidget: Center(child: CircularProgressIndicator()),
          successWidget: RefreshIndicator(
            onRefresh: () async {},
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<CartCubit>().getPostListing();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.getCartListingApiState.model?.length ?? 0,
                itemBuilder: (context, index) {
                  final cart = state.getCartListingApiState.model?[index];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Cart Id: ${cart?.id ?? ''}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Products List
                      ...?cart?.products?.map(
                        (product) => _builCartItemCards(product),
                      ),

                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _builCartItemCards(Product? product) {
    return Container(
      decoration: BoxDecoration(color: Colors.black),
      child: Column(
        children: [
          Text(
            "Product Id : ${product?.productId ?? ""}",
            style: TextStyle(color: Colors.white),
          ),
          Text(
            "Quantity : ${product?.quantity ?? 0}",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
