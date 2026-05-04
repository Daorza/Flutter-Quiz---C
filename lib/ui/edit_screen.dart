import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditScreen extends StatefulWidget {
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
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
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // kembali ke dashboard
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Data dihapus (dummy)")));
            },
            child: Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
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

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Data diupdate (dummy)")),
                      );
                      Navigator.pop(context);
                    }
                  },
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
