import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/firebase_service.dart';
import '../models/contact.dart';

class EditScreen extends StatefulWidget {
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseService _firebaseService = FirebaseService();

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
    final Map<String, dynamic> data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    docId = data['id'];
    namaController.text = data['nama'] ?? '';
    nimController.text = data['nim'] ?? '';
    tglController.text = data['tanggal_lahir'] ?? '';
    hobiController.text = data['hobi'] ?? '';
    hpController.text = data['no_hp'] ?? '';
    alamatController.text = data['alamat'] ?? '';
    existingImageUrl = data['foto'];
  }

  // ✅ Fungsi-fungsi (sama persis)
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  void handleUpdate() async {
    if (_formKey.currentState!.validate()) {
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
    final cs = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Data"),
        content: const Text("Yakin ingin menghapus data ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              await _firebaseService.deleteData(docId!);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Data mahasiswa telah dihapus")),
              );
            },
            child: const Text(
              "Hapus",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    BuildContext context,
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: isDark ? Colors.white : cs.onSurface),
        validator: (v) => v!.isEmpty ? "$label tidak boleh kosong" : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Edit Mahasiswa"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: confirmDelete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 📷 Photo picker
              GestureDetector(
                onTap: pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: cs.surface,
                      backgroundImage: _image != null
                          ? FileImage(_image!) as ImageProvider
                          : (existingImageUrl != null &&
                                    existingImageUrl!.startsWith('http')
                                ? NetworkImage(existingImageUrl!)
                                : null),
                      child:
                          (_image == null &&
                              (existingImageUrl == null ||
                                  existingImageUrl == ""))
                          ? Icon(
                              Icons.person,
                              size: 48,
                              color: cs.onSurface.withOpacity(0.3),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cs.primary,
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _buildField(
                context,
                "Nama",
                namaController,
                Icons.person_outline,
              ),
              _buildField(context, "NIM", nimController, Icons.badge_outlined),
              _buildField(
                context,
                "Tanggal Lahir",
                tglController,
                Icons.calendar_today_outlined,
              ),
              _buildField(
                context,
                "Hobi",
                hobiController,
                Icons.sports_esports_outlined,
              ),
              _buildField(
                context,
                "Nomor HP",
                hpController,
                Icons.phone_outlined,
              ),
              _buildField(
                context,
                "Alamat",
                alamatController,
                Icons.location_on_outlined,
              ),

              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: handleUpdate,
                  child: const Text(
                    "Simpan Perubahan",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
