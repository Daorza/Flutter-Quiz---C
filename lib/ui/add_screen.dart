import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/firebase_service.dart'; // Sesuaikan path-nya
import '../models/contact.dart'; // Sesuaikan path-nya

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseService _firebaseService = FirebaseService();

  final namaController = TextEditingController();
  final nimController = TextEditingController();
  final tglController = TextEditingController();
  final hobiController = TextEditingController();
  final hpController = TextEditingController();
  final alamatController = TextEditingController();

  File? _image;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  // Fungsi untuk memproses penyimpanan ke Firebase
  void _saveData() async {
    if (_formKey.currentState!.validate()) {
      // 1. Buat objek Mahasiswa dari inputan
      // Catatan: Karena kita belum setup Firebase Storage,
      // sementara kita simpan path lokal atau string kosong untuk foto.
      Mahasiswa mhsBaru = Mahasiswa(
        nama: namaController.text,
        nim: nimController.text,
        tanggalLahir: tglController.text,
        hobi: hobiController.text,
        noHp: hpController.text,
        alamat: alamatController.text,
        foto: _image != null ? _image!.path : "",
      );

      try {
        // 2. Panggil fungsi addData dari service Anda
        await _firebaseService.addData(mhsBaru.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data berhasil disimpan ke Firebase")),
        );

        // 3. Kembali ke Dashboard
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal menyimpan data: $e")));
      }
    }
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
      appBar: AppBar(title: const Text("Tambah Mahasiswa")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 📸 FOTO
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? const Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.grey,
                        )
                      : null,
                ),
              ),

              const SizedBox(height: 20),

              buildTextField("Nama", namaController),
              buildTextField("NIM", nimController),
              buildTextField("Tanggal Lahir", tglController),
              buildTextField("Hobi", hobiController),
              buildTextField("Nomor HP", hpController),
              buildTextField("Alamat", alamatController),

              const SizedBox(height: 20),

              // 💾 SIMPAN
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _saveData, // Panggil fungsi simpan
                  child: const Text(
                    "Simpan Data",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
