import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference mahasiswa = FirebaseFirestore.instance.collection('mahasiswa');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Mahasiswa"),
        centerTitle: true,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: mahasiswa.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Belum ada data mahasiswa!"),);
          }

          var data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var mhs = data[index];
              var mhsData = mhs.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6
                ),
                elevation: 3,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: mhsData['foto'] != null && mhsData['foto'] != ""
                        ? NetworkImage(mhsData['foto'])
                        : const AssetImage("assets/user.png")
                          as ImageProvider,
                  ),
                  title: Text(
                    mhsData['nama'] ?? "-",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("NIM: ${mhsData['nim'] ?? '-'}"),
                      Text("Hobi: ${mhsData['hobi'] ?? '-'}"),
                    ],
                  ),

                  onTap: () {
                    Navigator.pushNamed(context, '/detail', arguments: {
                      'id': mhs.id,
                      ...mhsData,
                    });
                  },
                ),
              );
            },
          );
        }
      ),

      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/add');
          },
        child: const Icon(Icons.add),
      ),
    );
  }
}