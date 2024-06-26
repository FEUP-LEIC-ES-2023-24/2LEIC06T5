
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pagepal/controller/queries.dart';
import 'package:pagepal/model/user.dart';


//TODO Call this when a user removes a book from library
void removeBookFromUser(User user, DocumentReference book) async{
  DocumentReference userRef = await Queries.getUserDocRef(user.email);
  FirebaseFirestore db = FirebaseFirestore.instance; 
  QuerySnapshot userExchangesSnapshot = await db.collection('incompleteExchanges').where('switchReceiver' ,isEqualTo: userRef).get();

  for (DocumentSnapshot userExchangeSnapshot in userExchangesSnapshot.docs){
    await userExchangeSnapshot.reference.update({
      'receiverBooks': FieldValue.arrayRemove([book])
    });

    DocumentSnapshot updatedDoc = await userExchangeSnapshot.reference.get();
    List<dynamic> updatedReceiverBooks = updatedDoc.get('receiverBooks');
    if (updatedReceiverBooks.isEmpty) {
      await userExchangeSnapshot.reference.delete();
    }
  }

  QuerySnapshot otherExchanges = await db.collection("incompleteExchanges").where('switchReceiver',isEqualTo: userRef).get();
  for (QueryDocumentSnapshot otherExchange in otherExchanges.docs) {
    Map<String,dynamic> otherExchangeData = otherExchange.data() as Map<String, dynamic>;
    List<DocumentReference> receiverBooks = otherExchangeData['receiverBooks'];
    receiverBooks.remove(book);
    if (receiverBooks.isEmpty) {
      await db.collection('incompleteExchanges').doc(otherExchange.id).delete();
    }
  }
}

