// 4
import 'package:fiwork/services/cloud/cloud_gig/cloud_gig.dart';
import 'package:fiwork/services/cloud/cloud_gig/cloud_gig_provider.dart';
import 'package:fiwork/services/cloud/cloud_gig/firebase_cloud_gig_provder.dart';

class CloudGigService implements CloudGigProvider {
  final CloudGigProvider provider;

  const CloudGigService(this.provider);

  factory CloudGigService.firebase() =>
      CloudGigService(FirebaseCloudGigProvider());

  @override
  Future<void> createNewGig(CloudGig cloudGig) =>
      provider.createNewGig(cloudGig);

  @override
  Stream<Iterable<CloudGig>> gigsByCategory(String category) =>
      provider.gigsByCategory(category);

  @override
  Future<List<CloudGig>> searchGigs(String keyword) =>
      provider.searchGigs(keyword);

  @override
  Stream<Iterable<CloudGig>> userAllGigs(String userId) =>
      provider.userAllGigs(userId);
  
  @override
  Stream<Iterable<CloudGig>> allGigs() => provider.allGigs();
 
}
