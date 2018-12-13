import 'package:cloud_firestore/cloud_firestore.dart';

class MyFirebase {
  final firestore = Firestore.instance.collection('pitch');
  final firebaseInstance = Firestore.instance;

  Future makeVote(DocumentSnapshot snapshot, int value) {
    firebaseInstance.runTransaction((transaction) async {
      final freshSnapshot = await transaction.get(snapshot.reference);

      await transaction.update(
          snapshot.reference, {'votes': freshSnapshot["votes"] + value});
    });
  }

  // Future makeVote(DocumentSnapshot snapshot, int value) async {
  //   await _lock.synchronized(() async {
  //     snapshot.reference.updateData({"votes": snapshot.data["votes"] + value});
  //   });
  // }

  void deleteIdea(DocumentSnapshot snapshot) {
    snapshot.reference.delete();
  }
}
