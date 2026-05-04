import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/firebase_service.dart'; // Sesuaikan path-nya
import '../models/contact.dart'; // Sesuaikan path-nya

class EditScreen extends StatefulWidget {
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseService _firebaseService = FirebaseService();

  // Controller
  final namaController = TextEditingController();
  final nimController = TextEditingController();
  final tglController = TextEditingController();
  final hobiController = TextEditingController();
  final hpController = TextEditingController();
  final alamatController = TextEditingController();

  String? docId;
  String? existingImageUrl;
  File? _image;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 🔥 Ambil data yang dikirim dari dashboard
    final Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Isi controller dengan data yang ada
    docId = data['id'];
    namaController.text = data['nama'] ?? '';
    nimController.text = data['nim'] ?? '';
    tglController.text = data['tanggal_lahir'] ?? '';
    hobiController.text = data['hobi'] ?? '';
    hpController.text = data['no_hp'] ?? '';
    alamatController.text = data['alamat'] ?? '';
    existingImageUrl = data['foto'];
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  // Fungsi untuk update data ke Firebase
  void handleUpdate() async {
    if (_formKey.currentState!.validate()) {
      // Kita buat model Mahasiswa untuk memudahkan
      Mahasiswa mhsUpdate = Mahasiswa(
        nama: namaController.text,
        nim: nimController.text,
        tanggalLahir: tglController.text,
        hobi: hobiController.text,
        noHp: hpController.text,
        alamat: alamatController.text,
        foto: _image != null ? _image!.path : (existingImageUrl ?? ""),
      );

      await _firebaseService.updateData(docId!, mhsUpdate.toMap());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Data berhasil diupdate")));
      Navigator.pop(context);
    }
  }

  void confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Hapus Data"),
        content: Text("Yakin ingin menghapus data ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              await _firebaseService.deleteData(docId!);
              Navigator.pop(context); // tutup dialog
              Navigator.pop(context); // kembali ke dashboard
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Data mahasiswa telah dihapus")),
              );
            },
            child: Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: (value) =>
            value!.isEmpty ? "$label tidak boleh kosong" : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Mahasiswa"),
        actions: [
          IconButton(icon: Icon(Icons.delete), onPressed: confirmDelete),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : (existingImageUrl != null &&
                                existingImageUrl!.startsWith('http')
                            ? NetworkImage(existingImageUrl!) as ImageProvider
                            : null),
                  child:
                      (_image == null &&
                          (existingImageUrl == null || existingImageUrl == ""))
                      ? Icon(Icons.camera_alt, size: 40)
                      : null,
                ),
              ),
              SizedBox(height: 20),
              buildTextField("Nama", namaController),
              buildTextField("NIM", nimController),
              buildTextField("Tanggal Lahir", tglController),
              buildTextField("Hobi", hobiController),
              buildTextField("Nomor HP", hpController),
              buildTextField("Alamat", alamatController),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: handleUpdate,
                  child: Text("Update"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
