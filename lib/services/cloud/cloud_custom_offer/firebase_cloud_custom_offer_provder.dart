// 3
import 'package:fiwork/services/cloud/cloud_custom_offer/cloud_custom_offer.dart';
import 'package:fiwork/services/cloud/cloud_custom_offer/cloud_custom_offer_provider.dart';
import 'package:fiwork/services/cloud/firebase_cloud_storage.dart';

class FirebaseCloudCustomOfferProvider extends CloudCustomOfferProvider {
  FirebaseCloudStorage firebaseCloudStorage = FirebaseCloudStorage();
  
  final _offers = 'offers';

  @override
  Future<void> createNewCustomOffer(CloudCustomOffer cloudCustomOffer) async{
   await firebaseCloudStorage.firebaseFirestoreInstance()
        .collection(_offers)
        .doc(cloudCustomOffer.orderId)
        .set(
          cloudCustomOffer.toJson(),
        );
  }

  @override
  Future<String> deleteOffer(String orderId) async {
    String res = "Some error occurred";
    try {
      await firebaseCloudStorage.firebaseFirestoreInstance().collection(_offers).doc(orderId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  @override
  Stream<Iterable<CloudCustomOffer>> userAllReceivedOffers(String userId) {
     return firebaseCloudStorage.firebaseFirestoreInstance()
        .collection(_offers)
        .where('employer_id', isEqualTo: userId).snapshots().map(
          (event) => event.docs.map(
            (doc) => CloudCustomOffer.fromSnapshot(doc),
          ),
        );
  }

  @override
  Stream<Iterable<CloudCustomOffer>> userAllSentOffers(String userId) {
    return firebaseCloudStorage.firebaseFirestoreInstance().collection(_offers)
        .where('user_id', isEqualTo: userId).snapshots().map(
          (event) => event.docs.map(
            (doc) => CloudCustomOffer.fromSnapshot(doc),
          ),
        );
  }

  
}
