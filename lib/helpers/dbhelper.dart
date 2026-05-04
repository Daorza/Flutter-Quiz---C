import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/models/contact.dart';

class DbHelper {
  final CollectionReference contacts = FirebaseFirestore.instance.collection('contacts');

  Future<void> insert(Contact contact) async {
    await contacts.add(contact.toMap());
  }

  Future<List<Contact>> getContactList() async {
    QuerySnapshot snapshot = await contacts.get();

    return snapshot.docs.map((doc) {
      return Contact.fromMap(
          doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }).toList();
  }

  Future<void> update(Contact contact) async {
    await contacts.doc(contact.id).update(contact.toMap());
  }

  Future<void> delete(String id) async {
    await contacts.doc(id).delete();
  }
}