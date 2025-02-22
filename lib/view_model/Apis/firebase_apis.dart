import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseApis {
  static final _firestore = FirebaseFirestore.instance;

  // Collection
  static CollectionReference userCollectionRef = _firestore.collection("Users");

  // Document References
  static DocumentReference userDocumentRef(String id) =>
      userCollectionRef.doc(id);
}
