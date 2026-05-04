import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference mahasiswa =
      FirebaseFirestore.instance.collection('mahasiswa');

  Future<void> addData(Map<String, dynamic> data) async {
    await mahasiswa.add(data);
  }

  Stream<QuerySnapshot> getData() {
    return mahasiswa.snapshots();
  }

  Future<void> updateData(String id, Map<String, dynamic> data) async {
    await mahasiswa.doc(id).update(data);
  }

  Future<void> deleteData(String id) async {
    await mahasiswa.doc(id).delete();
  }
}