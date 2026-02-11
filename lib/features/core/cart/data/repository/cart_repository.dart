part of 'repository.dart';

class CartRepository {
  CartRepository(this.generalRepository);

  final GeneralRepository generalRepository;

  Future<List<CartListingModel>> getPostListing() async {
    var jsonData = await generalRepository.get(
      handle: AppApis.postsListing,
      header: {'User-Agent': 'Mozilla/5.0', 'Accept': 'application/json'},
    );

    return (jsonData as List).map((e) => CartListingModel.fromJson(e)).toList();
  }

  Future<void> addCart(CartAddParams params) async {
    String encodedBody = jsonEncode(params.toJson());
    await generalRepository.post(handle: AppApis.addCart, body: encodedBody);
  }
}
