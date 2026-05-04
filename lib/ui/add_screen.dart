import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();

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
      appBar: AppBar(title: Text("Tambah Mahasiswa")),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 📸 FOTO
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
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

              // 💾 SIMPAN
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // nanti connect Firebase
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Data disimpan (dummy)")),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Simpan"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
