import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:olxm_project/model/data.dart';

class CommentService {
  final CollectionReference commentsCollection =
      FirebaseFirestore.instance.collection('comments');

  Future<void> addComment(String userId, String text, String productId) async {
    await commentsCollection.add({
      'userId': userId,
      'productId': productId,
      'text': text,
      'createdAt': Timestamp.now(),
    });
  }

  Stream<List<Comment>> getComments() {
    return commentsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final id = doc.id;
              final userId = data['userId'] as String;
              final productId = data['productId'] as String;
              final text = data['text'] as String;
              final createdAt =
                  (data['createdAt'] as Timestamp?) ?? Timestamp.now();

              return Comment(
                id: id,
                userId: userId,
                productId: productId,
                text: text,
                createdAt: createdAt,
              );
            }).toList());
  }
}
