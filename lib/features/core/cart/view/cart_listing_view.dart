part of 'view.dart';

class CartListingView extends StatelessWidget {
  const CartListingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              color: Colors.red,
              height: 40,
              child:Text("hello world") ,
            )
          ],
        ),
      ),
    );
  }
}