import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCloudStorage {
  final firebaseFirestore = FirebaseFirestore.instance;

  FirebaseCloudStorage._sharedInstance();
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  FirebaseFirestore firebaseFirestoreInstance() {
    return firebaseFirestore;
  }
}
