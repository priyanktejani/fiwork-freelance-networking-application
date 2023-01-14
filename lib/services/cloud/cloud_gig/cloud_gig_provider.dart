// 2
import 'package:fiwork/services/cloud/cloud_gig/cloud_gig.dart';

abstract class CloudGigProvider {
  Future<void> createNewGig(CloudGig cloudGig);

  Future<List<CloudGig>> searchGigs(String keyword);

  Stream<Iterable<CloudGig>> gigsByCategory(String category);

  Stream<Iterable<CloudGig>> userAllGigs(String userId);

  Stream<Iterable<CloudGig>> allGigs();
}
