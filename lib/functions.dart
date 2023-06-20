import 'package:cloud_firestore/cloud_firestore.dart';

class Functions {
  static Future<void> setOrUpdateFirestore(DocumentReference? docRef,
      String dictRoot, String path, var value) async {
    if (docRef != null) {
      DocumentSnapshot doc = await docRef.get();
      if (doc.exists) {
        Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
        if (!docData.containsKey(dictRoot)) {
          await docRef.update({dictRoot: {}});
        }
      } else {
        await docRef.set({dictRoot: {}});
      }
      await docRef.update({path: value});
    }
  }
}
