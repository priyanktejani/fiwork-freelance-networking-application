// 4
import 'package:fiwork/services/cloud/cloud_custom_offer/cloud_custom_offer.dart';
import 'package:fiwork/services/cloud/cloud_custom_offer/cloud_custom_offer_provider.dart';
import 'package:fiwork/services/cloud/cloud_custom_offer/firebase_cloud_custom_offer_provder.dart';

class CloudCustomOfferService implements CloudCustomOfferProvider {
  final CloudCustomOfferProvider provider;

  const CloudCustomOfferService(this.provider);

  factory CloudCustomOfferService.firebase() =>
      CloudCustomOfferService(FirebaseCloudCustomOfferProvider());

  @override
  Future<void> createNewCustomOffer(CloudCustomOffer cloudCustomOffer) =>
      provider.createNewCustomOffer(cloudCustomOffer);

  @override
  Future<String> deleteOffer(String orderId) => provider.deleteOffer(orderId);

  @override
  Stream<Iterable<CloudCustomOffer>> userAllReceivedOffers(String userId) =>
      provider.userAllReceivedOffers(userId);

  @override
  Stream<Iterable<CloudCustomOffer>> userAllSentOffers(String userId) =>
      provider.userAllSentOffers(userId);
}
