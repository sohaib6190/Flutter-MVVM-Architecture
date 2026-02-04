part of 'repository.dart';

class CartRepository {
  CartRepository(this.generalRepository);

  final GeneralRepository generalRepository;


  Future<void> cancelBooking(int bookingId) async {
    await generalRepository.delete(handle: '${AppApis.changePassword}/$bookingId');
  }

 
}
