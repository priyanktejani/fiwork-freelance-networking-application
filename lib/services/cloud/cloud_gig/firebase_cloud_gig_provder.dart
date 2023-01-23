import 'package:fiwork/services/cloud/cloud_gig/cloud_gig.dart';
import 'package:fiwork/services/cloud/cloud_gig/cloud_gig_provider.dart';
import 'package:fiwork/services/cloud/firebase_cloud_storage.dart';

class FirebaseCloudGigProvider extends CloudGigProvider {
  FirebaseCloudStorage firebaseCloudStorage = FirebaseCloudStorage();

  final _gigs = 'gigs';

  @override
  Future<void> createNewGig(CloudGig cloudGig) async {
    await firebaseCloudStorage
        .firebaseFirestoreInstance()
        .collection(_gigs)
        .doc(cloudGig.gigId)
        .set(
          cloudGig.toJson(),
        );
  }

  @override
  Stream<Iterable<CloudGig>> gigsByCategory(String category) {
    return firebaseCloudStorage
        .firebaseFirestoreInstance()
        .collection(_gigs)
        .where('gig_category', isEqualTo: category)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (doc) => CloudGig.fromSnapshot(doc),
          ),
        );
  }

  @override
  Future<List<CloudGig>> searchGigs(String keyword) {
    if (keyword.isNotEmpty) {
      return firebaseCloudStorage
          .firebaseFirestoreInstance()
          .collection(_gigs)
          .where('gig_title', isGreaterThanOrEqualTo: keyword.toUpperCase())
          .get()
          .then(
            (querySnapshot) => querySnapshot.docs
                .map(
                  (doc) => CloudGig.fromSnapshot(doc),
                )
                .toList(),
          );
    } else {
      return firebaseCloudStorage
          .firebaseFirestoreInstance()
          .collection(_gigs)
          .get()
          .then(
            (querySnapshot) => querySnapshot.docs
                .map(
                  (doc) => CloudGig.fromSnapshot(doc),
                )
                .toList(),
          );
    }
  }

  @override
  Stream<Iterable<CloudGig>> userAllGigs(String userId) {
    return firebaseCloudStorage
        .firebaseFirestoreInstance()
        .collection(_gigs)
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map(
          (event) => event.docs.map(
            (doc) => CloudGig.fromSnapshot(doc),
          ),
        );
  }

  @override
  Stream<Iterable<CloudGig>> allGigs() => firebaseCloudStorage
      .firebaseFirestoreInstance()
      .collection(_gigs)
      .snapshots()
      .map(
        (event) => event.docs.map(
          (doc) => CloudGig.fromSnapshot(doc),
        ),
      );
}
